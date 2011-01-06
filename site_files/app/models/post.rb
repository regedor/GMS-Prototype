class Post < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  acts_as_taggable

  has_many                :comments, :dependent => :destroy
  has_many                :approved_comments, :class_name => 'Comment'

  before_validation       :generate_slug
  before_validation       :set_dates
  before_save             :apply_filter

  validates_presence_of   :title, :slug, :body

  validate                :validate_published_at_natural

  named_scope :not_deleted, :conditions => {:deleted => false}


  def authorized_for?(*args)
    #!deleted
    true
  end

  def validate_published_at_natural
    errors.add("published_at_natural", "Unable to parse time") unless published?
  end

  attr_accessor :minor_edit
  def minor_edit
    @minor_edit ||= "1"
  end

  def minor_edit?
    self.minor_edit == "1"
  end

  def published?
    published_at?
  end

  attr_accessor :published_at_natural
  def published_at_natural
    @published_at_natural ||= published_at.send_with_default(:strftime, 'now', "%Y-%m-%d %H:%M")
  end

  def month
    published_at.beginning_of_month
  end

  def apply_filter
    self.body_html = EnkiFormatter.format_as_xhtml(self.body)
  end

  def set_dates
    self.edited_at = Time.now if self.edited_at.nil? || !minor_edit?
    self.published_at = Chronic.parse(self.published_at_natural)
  end

  def denormalize_comments_count!
    Post.update_all(["approved_comments_count = ?", self.approved_comments.count], ["id = ?", self.id])
  end

  def generate_slug
    self.slug = self.title.dup if self.slug.blank?
    self.slug.slugorize!
  end

  def tag_list=(value)
    value = value.join(", ") if value.respond_to?(:join)
    super(value)
  end

  class << self

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

    def find_all_grouped_by_month
      posts = find :all,
                   :order      => 'posts.published_at DESC',
                   :conditions => ['published_at < ?', Time.now]
      month = Struct.new(:date, :posts)
      posts.group_by(&:month).inject([]) {|a, v| a << month.new(v[0], v[1])}
    end

    def paginate_by_published_date(page)
      paginate :per_page => 5, :page => page,
               :order => "published_at DESC"
    end

    def paginate_with_tag_names(tags, page = 1)
      tag_ids = Tag.all :select => "id",
                        :conditions => { :name => tags }
      paginate_with_tag_ids(tag_ids, page)
    end

    def paginate_with_tag_ids(tags, page = 1)
      options =  { :page       => page,
                   :per_page   => DEFAULT_LIMIT,
                   :order      => 'posts.published_at DESC',
                   :conditions => ['published_at < ?', Time.zone.now] }
      options.merge! tags_filter(tags)
      Post.paginate options
    end

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
             :select     => "*, COUNT(*) as tag_count",
             :group      => "taggings.taggable_id",
             :joins      => :taggings,
             :conditions => { "taggings.tag_id" => tags }
           }) + ") as posts"
        }
      end
    end
  end
end
