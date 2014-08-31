class PostImage
  include Mongoid::Document

  embedded_in :website_post

  field :scrapped_at, type: DateTime
  field :key, type: String
  
  validates_uniqueness_of :key, :scope => :website_post
end