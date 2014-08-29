class WebsitePost
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  embedded_in :user_website
  embeds_many :post_images
end