class UserWebsite
  include Mongoid::Document
  include Mongoid::Timestamps

  #field :website_id, type: String
  field :name, type: String
  field :url, type: String
  embedded_in :user
  embeds_many :website_posts

  validates_uniqueness_of :name, :scope => :user
  validates_uniqueness_of :url, :scope => :user

  def update_posts
    website_posts.each do |post|
      post.update_images
    end
  end
end