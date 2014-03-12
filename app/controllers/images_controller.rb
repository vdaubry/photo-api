class ImagesController < ApplicationController
  before_action :set_website, only: [:index, :update, :destroy, :destroy_all, :redownload, :search, :create]
  before_action :set_post, only: [:index, :update, :destroy, :destroy_all, :redownload, :create]
  before_action :set_image, only: [:update, :destroy, :redownload]
  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound, :with => :render_404

  def index
    @to_sort_count = @website.images.where(:status => Image::TO_SORT_STATUS).count
    @to_keep_count = @website.images.where(:status => Image::TO_KEEP_STATUS).count
    @to_delete_count = @website.images.where(:status => Image::TO_DELETE_STATUS).count

    status = params["status"].nil? ? Image::TO_SORT_STATUS : params["status"]
    
    if status==Image::TO_SORT_STATUS
      @images = @post.images.where(:status => status).asc(:created_at).page(params[:page])
    else 
      @images = @website.images.where(:status => status).desc(:updated_at).page(params[:page])
    end

    options = { :to_sort_count => @to_sort_count, :to_keep_count => @to_keep_count, :to_delete_count => @to_delete_count }
    options.merge!({:post_name => @post.name}) if @post.present?

    respond_with @images, :each_serializer => ImageSerializer, :meta => options
  end

  def create
    return render_404 if @post.nil?

    image = @post.images.create(post_params.merge(:website => @website))
    respond_with image do |format|
      format.json { render json: image }
    end
  end

  def search
    images = if params[:source_url].present?
                @website.images.where(:source_url => params[:source_url])
              elsif params[:hosting_url].present?
                @website.images.where(:hosting_url => params[:hosting_url])
              elsif params[:hosting_urls].present?
                @website.images.where(:hosting_url.in => params[:hosting_urls])
              else
                []
              end
    respond_with images
  end

  def update
    @image.update_attributes(
      status: Image::TO_KEEP_STATUS
    )
    @post.check_status!

    render :json => {:status => "ok"}
  end

  def destroy
    @image.update_attributes(
      status: Image::TO_DELETE_STATUS
    )
    @post.check_status!
    
    render :json => {:status => "ok"}
  end

  def destroy_all
    if params["ids"]
      @website.images.where(:_id.in => params["ids"]).update_all(
          status: Image::TO_DELETE_STATUS
      ) 
    end
    @post.check_status!
    next_post_id = @website.latest_post.id.to_s rescue nil

    render :json => {:next_post_id => next_post_id}
  end 

  def redownload
    @image.download

    render :json => {:status => "ok"}
  end

  private
    def set_image
      @image = Image.find(params[:id])
    end

    def set_post
      @post = Post.where(:id => params[:post_id]).first
    end

    def set_website
      @website = Website.find(params[:website_id])
    end

      # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:image).permit(:key, :source_url, :hosting_url, :status, :image_hash, :width, :height, :file_size)
    end
end
