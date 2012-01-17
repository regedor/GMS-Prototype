class Tag < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  has_many                :taggings, :dependent => :destroy

  validates_presence_of   :name
  validates_uniqueness_of :name

  # Update taggables' cached_tag_list
  after_destroy do |tag|
    tag.taggings.each do |tagging|
      taggable = tagging.taggable
      if taggable.class.caching_tag_list?
        taggable.tag_list = TagList.new(*taggable.tags.map(&:name))
        taggable.save
      end
    end
  end

  # Update taggables' cached_tag_list
  after_update do |tag|
    tag.taggings.each do |tagging|
      taggable = tagging.taggable
      if taggable.class.caching_tag_list?
        taggable.tag_list = TagList.new(*taggable.tags.map(&:name))
        taggable.save
      end
    end
  end

  cattr_accessor :destroy_unused
  self.destroy_unused = false

  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end

  def to_s
    name
  end

  def count
    read_attribute(:count).to_i
  end

  class << self

    # LIKE is used for cross-database case-insensitivity
    def find_or_create_with_like_by_name(name)
      find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
    end
  
    def paginate_filtered_tags(tags, page = 1)
      Tag.paginate tags_filter(tags).merge :page     => page,
                                           :per_page => DEFAULT_LIMIT,
                                           :order    => 'taggings_count DESC'
    end

    def tags_for_cloud(tags)
      tag_ids = tags ? (Tag.all :select => "id", :conditions => { :name => tags }) : []
      Tag.all( tags_filter(tag_ids).merge :limit => 100,
                                          :order => 'taggings_count DESC, name'
             ).sort_by { |tag| tag.name.downcase }
    end

    def tags_for_menu(tags,limit)
      if tags.nil? || tags.empty?
        tag_ids = tags ? (Tag.all :select => "id", :conditions => { :name => tags }) : []
        return Tag.all( tags_filter(tag_ids).merge :limit => limit,
                                            :order => 'taggings_count DESC, name')
      elsif tags.size >= 1
        tag_ids = tags ? (Tag.all :select => "id", :conditions => { :name => tags[0] }) : []
        secondary_result_set = Tag.all( tags_filter(tag_ids).merge :limit => limit+1,
                                                 :order => 'taggings_count DESC, name')
        primary_result_set = Tag.all( tags_filter([]).merge :limit => limit,
                                            :order => 'taggings_count DESC, name')
        primary = secondary_result_set.shift
        return {:primary => primary.name, :primary_results => primary_result_set,:secondary_results => secondary_result_set}
      end
    end
  
    def tags_filter(tags)
      filter = { }
  
      if tags.empty?
        # OPTIONS IF NO FILTER IS NEEDED
        filter.merge! :conditions => 'taggings_count > 0'
  
      else
        # OPTIONS IF A FILTER IS NEEDED
        filter.merge! :select => "tags.id, tags.name, COUNT(*) as taggings_count",
                      :joins  => "INNER JOIN taggings ON tags.id = taggings.tag_id",
                      :group  => "tags.id"
  
        if tags.size == 1
          # OPTIONS FOR A SINGLE TAG FILTER (REQUIRES ONE EXTRA NESTED QUERY)
          filter.merge! :select     => "tags.id, tags.name, COUNT(*) as taggings_count",
                        :joins      => "INNER JOIN taggings ON tags.id = taggings.tag_id",
                        :group      => "tags.id",
                        :conditions => "taggings.taggable_id IN (" + Post.send(:construct_finder_sql,
                          {
                            :select     => "posts.id",
                            :joins      => :taggings,
                            :conditions => { "taggings.tag_id" => tags }
                          }) + ")"
  
        else
          # OPTIONS FOR A MULTIPLE TAG FILTER (REQUIRES TWO EXTRA NESTED QUERIES)
          filter.merge! :select => "tags.id, tags.name, COUNT(*) as taggings_count",
                        :joins  => "INNER JOIN taggings ON tags.id = taggings.tag_id",
                        :group  => "tags.id",
                        :conditions => "taggings.taggable_id IN (" + Post.send(:construct_finder_sql,
                          {
                            :conditions => { "tag_count" => tags.size },
                            :select     => "posts.id",
                            :from       => "(" + Post.send(:construct_finder_sql,
                              {
                                :select     => "posts.id, COUNT(*) as tag_count",
                                :group      => "taggings.taggable_id",
                                :joins      => :taggings,
                                :conditions => { "taggings.tag_id" => tags }
                            }) + ") as posts",
                          }) + ")"
        end
      end
  
      return filter
    end
  end
end
