class PostsController < ApplicationController
  before_action :set_website, only: [:destroy, :create, :search, :update, :banish]
  before_action :set_post, only: [:destroy, :update, :banish]
  respond_to :json

  def destroy
    @post.images.where(:status => Image::TO_SORT_STATUS).update_all(:status => Image::TO_DELETE_STATUS)
    @post.update_attributes(:status => Post::SORTED_STATUS)
    
    render :json => {:latest_post => @website.latest_post_id} 
  end

  def create
    post = @website.posts.find_or_initialize_by(:name => params[:post][:name]) rescue nil
    if post
      Librato.increment 'post.create'
      Librato.increment "#{@website.name}.post.create"
      post.status = Post::TO_SORT_STATUS
      post.save
    end
    respond_with post do |format|
      format.json { render json: post }
    end
  end

  def search
    posts = @website.posts.with_page_url(params[:page_url])
    respond_with posts
  end

  def update
    @post.add_to_set(pages_url: params[:post][:page_url])
    @post.save

    respond_with @post do |format|
      format.json { render json: @post }
    end
  end

  def banish
    @post.update_attributes(banished: true)
    render :json => {:latest_post => @website.latest_post_id} 
  end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_post
	  @post = @website.posts.find(params[:id])
	end

  def set_website
    @website = Website.find(params[:website_id])
  end
end