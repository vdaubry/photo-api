class Website
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :images
  has_many :scrappings
  has_many :posts

  field :name, type: String
  field :url, type: String

  def latest_post_id
    self.posts.where(:status => Post::TO_SORT_STATUS, :banished => false).order_by(:updated_at => :asc).first.id.to_s rescue nil
  end

end
