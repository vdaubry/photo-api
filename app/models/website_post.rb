class WebsitePost
  include Mongoid::Document
  include Mongoid::Timestamps
  
  TO_SORT_STATUS="TO_SORT_STATUS"
  SORTED_STATUS="SORTED_STATUS"

  embedded_in :user_website
  embeds_many :post_images
  
  #Pourquoi on stocke l'id plutôt que has_one posts ?
  field :post_id, type: String
  field :name, type: String
  field :status, type: String, default: TO_SORT_STATUS
  field :banished, type: Boolean

  BUFFER_SIZE=500
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

    puts "Total images in post #{images.count}"
  end
end
