class Website
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :images
  has_many :scrappings
  has_many :posts

  field :name, type: String
  field :url, type: String

  def latest_post
    self.posts.where(:status => Post::TO_SORT_STATUS).first
  end

end
