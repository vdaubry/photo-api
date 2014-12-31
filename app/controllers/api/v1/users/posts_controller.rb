class Api::V1::Users::PostsController < Api::V1::Users::BaseController
  before_filter :authenticate_user!
  before_action :set_website, only: [:index, :show]
  before_action :set_post, only: [:show, :update]
  
  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound, :with => :render_404

  def index
    params[:page] ||= 1
    params[:per] ||= 50
    posts = @website.posts.desc(:updated_at).page(params[:page]).per(params[:per])
    respond_with ActiveModel::ArraySerializer.new(posts, {:current_user => current_user, :root => "posts"}).to_json
  end
  
  def show
    current_page = UserPost.getCurrentPage(current_user, @post)
    respond_with PostSerializer.new(@post, {current_page: current_page, :current_user => current_user, :root => "posts"}).to_json
  end
  
  def update
    user_post = UserPost.setCurrentPage(current_user, @post, params[:current_page])
    old_pages_count = user_post.pages_seen && user_post.pages_seen.count
    #atomic update of array (to avoid race conditions)
    user_post.add_to_set(pages_seen: params[:current_page])
    
    if user_post.pages_seen.count != old_pages_count
      user_post.inc(images_seen_count: params[:images_seen]) if params[:images_seen]
    end
    
    render :status => 204, nothing: true
  end

  private  
    def set_post
      if params[:id] == "latest"
        @post = @website.posts.desc(:updated_at).first
      else
        @post = Post.find(params[:id])
      end
    end
    
    def set_website
      @website = Website.find(params[:website_id]) if params[:website_id]
    end
end
