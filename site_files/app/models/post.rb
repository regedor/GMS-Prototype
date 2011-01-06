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


  # Authorization for post
  def authorized_for?(*args)
    true
  end

  # Validate published status
  def validate_published_at_natural
    errors.add("published_at_natural", "Unable to parse time") unless published?
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

  attr_accessor :published_at_natural
  # Publication date at natural form. (e.g. 2011-01-01 00:00 )
  def published_at_natural
    @published_at_natural ||= published_at.send_with_default(:strftime, 'now', "%Y-%m-%d %H:%M")
  end

  # Returns the post's publication month
  def month
    published_at.beginning_of_month
  end

  # Sets body_html formatting body as html.
  def apply_filter
    self.body_html = EnkiFormatter.format_as_xhtml(self.body)
  end

  # Sets post dates
  def set_dates
    self.edited_at = Time.now if self.edited_at.nil? || !minor_edit?
    self.published_at = Chronic.parse(self.published_at_natural)
  end

  # Updates number of comments
  def denormalize_comments_count!
    Post.update_all(["approved_comments_count = ?", self.approved_comments.count], ["id = ?", self.id])
  end

  # Generates slug
  def generate_slug
    self.slug = self.title.dup if self.slug.blank?
    self.slug.slugorize!
  end

  # Generates the tag list from a tag array
  def tag_list=(value)
    value = value.join(", ") if value.respond_to?(:join)
    super(value)
  end

  class << self

    # Builds preview
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

    # Find by permalink
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

    # Paginate by publication date
    def paginate_by_published_date(page)
      paginate :per_page => 5, :page => page,
               :order => "published_at DESC"
    end

    # Paginates posts that contain the argument tag names
    def paginate_with_tag_names(tags, page = 1)
      tag_ids = Tag.all :select => "id",
                        :conditions => { :name => tags }
      paginate_with_tag_ids(tag_ids, page)
    end

    # Paginates posts that contain the argument tag ids
    def paginate_with_tag_ids(tags, page = 1)
      options =  { :page       => page,
                   :per_page   => DEFAULT_LIMIT,
                   :order      => 'posts.published_at DESC',
                   :conditions => ['published_at < ?', Time.zone.now] }
      options.merge! tags_filter(tags)
      Post.paginate options
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
