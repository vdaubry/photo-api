class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :source_url, :current_page, :images_count, :favorite_count, :images_seen

  def id
    object.id.to_s
  end
  
  def include_current_page?
    @options[:current_page].present?
  end
  
  def current_page
    @options[:current_page]
  end
  
  def include_images_seen?
    @options[:current_user].present?
  end
  
  def images_seen
    current_user = @options[:current_user]
    user_post = current_user.user_posts.where(:post => object).first
    user_post.try(:images_seen_count).to_i
  end
  
  def favorite_count
    if @options[:current_user]
      current_user = @options[:current_user]
      current_user.user_images.where(:post => object).count
    else
      0
    end
  end
  
  def images_count
    object.images.count
  end
  
end
