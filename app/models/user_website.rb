class UserWebsite
  include Mongoid::Document
  include Mongoid::Timestamps

  #TODO : pourquoi déclarer une string plutot que de déclarer has_one website ?
  field :website_id, type: String
  field :name, type: String
  field :url, type: String
  belongs_to :user
  embeds_many :website_posts

  validates_uniqueness_of :website_id, :scope => :user
  validates_uniqueness_of :name, :scope => :user
  validates_uniqueness_of :url, :scope => :user

  MAX_POSTS=1000

  def update_posts
    puts "total posts #{Website.find(website_id).posts.count}"

    posts = Website.find(website_id).posts.desc(:updated_at).limit(MAX_POSTS).not_in(:id => website_posts.map(&:post_id))

    puts "Adding #{posts.count} posts"

    puts Benchmark.measure {
      wp = []
      posts.batch_size(1000).each do |post|
        wp << WebsitePost.new(:post_id => post.id, :name => post.name)
      end
      website_posts.push(wp)
    }

    website_posts.each do |post|
      post.update_images
    end
  end

  def latest_post_id
    self.website_posts.where(:status => WebsitePost::TO_SORT_STATUS, :banished.ne => true).order_by(:updated_at => :asc).first.id.to_s rescue nil
  end
end