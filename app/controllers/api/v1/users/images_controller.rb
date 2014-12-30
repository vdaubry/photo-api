class Api::V1::Users::ImagesController < Api::V1::Users::BaseController
  before_filter :authenticate_user!
  before_action :set_post, only: [:index]
  
  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound, :with => :render_404

  def index
    params[:page] ||= 1
    params[:per] ||= 50
    image_ids = current_user.user_images.where(:post => @post).map(&:image_id)
    images = Image.where(:id.in => image_ids).asc(:scrapped_at).page(params[:page]).per(params[:per])
    respond_with images
  end


  private  
    def set_post
      @post = Post.find(params[:post_id])
    end
end
