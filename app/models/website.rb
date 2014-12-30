class Website
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :images
  has_many :posts
  has_one :user_image
  has_one :user_post

  field :name, type: String
  field :url, type: String

  index({name: 1}, :unique => true)
  index({url: 1}, :unique => true)
  
  validates_uniqueness_of :name, :url

  def latest_post_id
    self.posts.where(:status => Post::TO_SORT_STATUS).order_by(:updated_at => :asc).first.id.to_s rescue nil
  end

end
