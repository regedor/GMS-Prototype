class Post < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  acts_as_taggable

  ##FIXME: Need review!!!
  has_many                :approved_comments, :as => 'commentable', :dependent => :destroy, :class_name => 'Comment'
  belongs_to :group
  belongs_to :event
  #has_many                :approved_comments, :class_name => 'Comment'

  before_validation       :generate_slug
  before_validation       :set_dates
  before_save             :apply_filter

  validates_presence_of   :title, :slug, :body, :published_at
  validates_uniqueness_of :slug
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/jpg', 'image/png']


  named_scope :not_deleted, :conditions => {:deleted => false}
  named_scope :viewable_only, lambda { |user| {
      :conditions => (user.nil?) ? {"posts.group_id",[0]} : {"posts.group_id",user.group_ids+[0]}
    }
  }

  has_attached_file :image, :styles => { :image => "250x250", :thumb => "50x50" }
  has_attached_file :generic
  before_save do |instance|
    instance.image.clear   if instance.image_delete == "1"
    instance.generic.clear if instance.generic_delete == "1"
  end
  attr_writer :image_delete, :generic_delete
  def image_delete ; @image_delete ||= "0" ; end
  def generic_delete ; @generic_delete ||= "0" ; end

  # Makes this model historicable
  include HistoryEntry::Historicable

  attr_accessor :do_history  
  
  def update_attribute_without_history(attr_name,attr_value)
    @do_history = false
    self.update_attribute attr_name, attr_value
  end

  # Authorization for post
  def authorized_for?(*args)
    true
  end

  attr_accessor :minor_edit
  # Sets minor edition
  def minor_edit
    @minor_edit ||= "1"
  end

  # Checks if it's a minor edition
  def minor_edit?
    self.minor_edit == "1"
  end

  # Publication date
  def published?
    published_at?
  end

  # Returns the post's publication month
  def month
    published_at.beginning_of_month
  end

  # Sets excerpt_html and body_html formatted as xhtml.
  def apply_filter
    formatted = TextFormatter.format_as_xhtml_with_excerpt(self.body)
    self.splitted = formatted[:splitted]
    self.excerpt_html = formatted[:excerpt]
    self.body_html = formatted[:body]
  end

  # Sets post dates
  def set_dates
    self.edited_at = Time.now if self.edited_at.nil? || !minor_edit?
  end

  # Generates a unique slug
  def generate_slug
    new_slug = self.title.dup.slugorize
    if self.slug.blank? || !self.slug.starts_with?(new_slug)
      repeated = Post.all(:select => 'COUNT(*) as id', :conditions => { :slug => self.slug }).first.id
      self.slug = (repeated > 0) ? "#{new_slug}-#{repeated + 1}" : new_slug
    end 
  end 

  # Generates the tag list from a tag array
  def tag_list=(value)
    value = value.join(", ") if value.respond_to?(:join)
    super(value)
  end

  def attributes=(new_attributes, guard_protected_attributes = true) 
    super(new_attributes,guard_protected_attributes)
    if new_attributes
      self.cached_tag_list = "" unless new_attributes["cached-tag-list"]
    end
  end

  class << self

    # Builds preview from params
    def build_for_preview(params)
      post = Post.new(params)
      post.generate_slug
      post.set_dates
      post.apply_filter
      TagList.from(params[:tag_list]).each do |tag|
        post.tags << Tag.new(:name => tag)
      end
      post
    end

    # Finds a post by its slug
    def find_by_slug slug
      (Post.all :conditions => { :slug => slug }).first
    end

    # Finds a post by its permalink
    def find_by_permalink(year, month, day, slug, options = {}) 
      begin
        day = Time.parse([year, month, day].collect(&:to_i).join("-")).midnight
        post = find_all_by_slug(slug, options).detect do |post|
          [:year, :month, :day].all? {|time|
            post.published_at.send(time) == day.send(time)
          }   
        end 
      rescue ArgumentError # Invalid time
        post = nil 
      end 
      post || raise(ActiveRecord::RecordNotFound)
    end 

    # Find all posts grouped by month
    def find_all_grouped_by_month
      posts = find :all,
        :order      => 'posts.published_at DESC',
        :conditions => ['published_at < ?', Time.now]
      month = Struct.new(:date, :posts)
      posts.group_by(&:month).inject([]) {|a, v| a << month.new(v[0], v[1])}
    end
    
    def all(*params)
      unless params.member? :order
        self.find :all, :order => 'posts.published_at DESC', *params     
      else
        self.find :all, *params
      end    
    end  

    # Paginate by publication date
    def paginate_by_published_date(page)
      paginate :per_page => 5, :page => page,
        :order => "published_at DESC"
    end

    # Paginates posts that contain the argument tag names
    def paginate_with_tag_names(user,tags, page = 1)
      tag_ids = Tag.all :select => "id",
        :conditions => { :name => tags }
      paginate_with_tag_ids(user,tag_ids, page)
    end

    # Paginates posts that contain the argument tag ids
    def paginate_with_tag_ids(user,tags, page = 1)
      options =  { :page       => page,
                   :per_page   => DEFAULT_LIMIT,
                   :order      => 'posts.published_at DESC',
                   :conditions => ['published_at < ?', Time.zone.now] }
      options.merge! tags_filter(tags)
        
      Post.viewable_only(user).paginate options
    end

    # Generates an option hash that only retrieves posts with the argument tags
    def tags_filter(tags)
      if tags.empty?
        return {}

      elsif tags.size == 1
        return {
          :joins      => :taggings,
          :conditions => { "taggings.tag_id" => tags }
        }

      else
        return {
          :conditions => { "tag_count" => tags.size },
          :from       => "(" + Post.send(:construct_finder_sql,
                                         {
                                           :select     => "posts.*, COUNT(*) as tag_count",
                                           :group      => "taggings.taggable_id",
                                           :joins      => :taggings,
                                           :conditions => { "taggings.tag_id" => tags }
          }) + ") as posts"
        }
      end
    end
  end
end
