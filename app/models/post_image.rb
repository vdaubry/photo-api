class PostImage
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :website_post

  field :key, type: String
  
  validates_uniqueness_of :key, :scope => :website_post
end