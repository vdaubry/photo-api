class WebsitePost
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :user_website
  embeds_many :post_images
  
  field :post_id, type: String
  field :name, type: String

  def update_images
    Post.find(post_id).images.batch_size(1000).each do |image|
      post_images.push(PostImage.new(:key => image.key))
    end
  end
end