class ImagesController < ApplicationController
  before_action :set_website, only: [:index, :update, :destroy, :destroy_all, :redownload]
  before_action :set_post, only: [:index, :update, :destroy, :destroy_all, :redownload]
  before_action :set_image, only: [:update, :destroy, :redownload]

  # GET /images
  # GET /images.json
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
  end


  # GET /images/1
  # GET /images/1.json
  def show
  end

  # PATCH/PUT /images/1
  def update
    @image.update_attributes(
      status: Image::TO_KEEP_STATUS
    )

    @post.check_status!
  end

  # DELETE /images/1
  def destroy
    @image.update_attributes(
      status: Image::TO_DELETE_STATUS
    )

    @post.check_status!
  end

  # DELETE /images/
  def destroy_all
    if params["image"] && params["image"]["ids"]
      @website.images.where(:_id.in => params["image"]["ids"]).update_all(
          status: Image::TO_DELETE_STATUS
      ) 
    end

    @post.check_status!
    next_post = @website.latest_post

    if next_post
      redirect_to website_post_images_url(@website, next_post)
    else
      redirect_to root_url
    end
  end 

  def redownload
    @image.download
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    def set_post
      @post = params[:post_id].nil? ? @website.latest_post : @website.posts.find(params[:post_id])
    end

    def set_website
      @website = Website.find(params[:website_id])
    end
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.permit(:id, :image_id)
    end
end
