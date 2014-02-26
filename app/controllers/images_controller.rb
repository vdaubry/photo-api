class ImagesController < ApplicationController
  before_action :set_website, only: [:index, :update, :destroy, :destroy_all, :redownload]
  before_action :set_post, only: [:index, :update, :destroy, :destroy_all, :redownload]
  before_action :set_image, only: [:update, :destroy, :redownload]
  respond_to :json

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

    respond_with @images, :each_serializer => ImageSerializer, :meta => { :to_sort_count => @to_sort_count, :to_keep_count => @to_keep_count, :to_delete_count => @to_delete_count }
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
    if params["image"] && params["image"]["ids"]
      @website.images.where(:_id.in => params["image"]["ids"]).update_all(
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
end
