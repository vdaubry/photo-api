class Api::V1::Users::ImagesController < Api::V1::Users::BaseController
  before_filter :authenticate_user!
  before_action :set_post, only: [:index, :update]
  before_action :set_image, only: [:update]
  
  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound, :with => :render_404

  def index
    image_ids = current_user.user_images.where(:post => @post).map(&:image_id)
    images = Image.where(:id.in => image_ids).asc(:scrapped_at)
    respond_with images
  end
  
  def update
    user_image = UserImage.new(:user => current_user, :website => @post.website, :post => @post, :image => @image)
    current_user.user_images.push(user_image)
    render :status => 201, nothing: true
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end
    
    def set_image
      @image = Image.find(params[:id])
    end
end
