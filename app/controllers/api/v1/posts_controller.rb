class Api::V1::PostsController < Api::V1::ApplicationController
  before_action :set_website, only: [:index, :show]
  before_action :set_post, only: [:show]
  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound, :with => :render_404


  def index
    params[:page] ||= 1
    params[:per] ||= 50
    respond_with @website.posts.desc(:updated_at)
  end
  
  def show
    respond_with @post, :root => "posts"
  end

  # def destroy
  #   @post.images.where(:status => Image::TO_SORT_STATUS).update_all(:status => Image::TO_DELETE_STATUS)
  #   @post.update_attributes(:status => Post::SORTED_STATUS)
    
  #   render :json => {:latest_post => @website.latest_post_id} 
  # end

  # def create
  #   post = @website.posts.find_or_initialize_by(:name => params[:post][:name]) rescue nil
  #   if post
  #     Librato.increment 'post.create'
  #     Librato.increment "#{@website.name}.post.create"
  #     post.status = Post::TO_SORT_STATUS
  #     post.save
  #   end
  #   respond_with post do |format|
  #     format.json { render json: post }
  #   end
  # end

  # def search
  #   posts = @website.posts.with_page_url(params[:page_url])
  #   respond_with posts
  # end

  # def update
  #   @post.add_to_set(pages_url: params[:post][:page_url])
  #   @post.save

  #   respond_with @post do |format|
  #     format.json { render json: @post }
  #   end
  # end

  # def banish
  #   @post.update_attributes(banished: true)
  #   render :json => {:latest_post => @website.latest_post_id} 
  # end

	private
	def set_post
	  if params[:id] == "latest"
      @post = @website.posts.desc(:updated_at).first
    else
      @post = Post.find(params[:id])
    end
	end

  def set_website
    @website = Website.find(params[:website_id])
  end
end