class WebsitePost
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :user_website
  embeds_many :post_images
  
  field :post_id, type: String
  field :name, type: String

  BUFFER_SIZE=150
  MAX_IMAGES=1000

  def update_images
    puts "total images for post #{Post.find(post_id).images.count}"
    puts "current images in post : #{post_images.count}"

    images = Post.find(post_id).images.not_in(:key => post_images.map(&:key))

    puts "Adding #{images.count} images"

    puts Benchmark.measure {    
      if images.count>0
        pi = []
        images.desc(:scrapped_at).limit(MAX_IMAGES).batch_size(100).each do |image|
          pi << PostImage.new(:key => image.key)
          if pi.count >= BUFFER_SIZE
            puts "flushing buffer at #{DateTime.now}"
            post_images.push(pi)
            pi = []
          end
        end
        post_images.push(pi) 
      end
    }
  end
end
