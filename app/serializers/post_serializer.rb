class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :source_url, :current_page, :images_count, :favorite_count

  def id
    object.id.to_s
  end
  
  def include_current_page?
    @options[:current_page].present?
  end
  
  def current_page
    @options[:current_page]
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
    if @options[:current_user]
      current_user = @options[:current_user]
      user_post = current_user.user_posts.where(:post => object).first
      user_post.nil? ? object.images.count : object.images.count - user_post.images_seen_count
    else
      object.images.count
    end
  end
end
