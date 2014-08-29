class UserWebsite
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :url, type: String
  embedded_in :user
  embeds_many :website_posts

  validates_uniqueness_of :name, :scope => :user
  validates_uniqueness_of :url, :scope => :user
end