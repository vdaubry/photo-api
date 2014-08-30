class UserWebsite
  include Mongoid::Document
  include Mongoid::Timestamps

  field :website_id, type: String
  field :name, type: String
  field :url, type: String
  embedded_in :user
  embeds_many :website_posts

  validates_uniqueness_of :website_id, :scope => :user
  validates_uniqueness_of :name, :scope => :user
  validates_uniqueness_of :url, :scope => :user

  def update_posts
    Website.find(website_id).posts.batch_size(1000).each do |post|
      wp = WebsitePost.new(:post_id => post.id, :name => post.name)
      website_posts.push(wp)
    end

    website_posts.each do |post|
      post.update_images
    end
  end
end