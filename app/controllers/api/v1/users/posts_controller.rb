class Api::V1::Users::PostsController < Api::V1::Users::BaseController
  before_filter :authenticate_user!
  before_action :set_website, only: [:index]
  before_action :set_post, only: [:show]
  
  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound, :with => :render_404

  def index
    params[:page] ||= 1
    params[:per] ||= 50
    respond_with @website.posts.desc(:updated_at).page(params[:page]).per(params[:per])
  end
  
  def show
    user_post=current_user.user_posts.where(:post_id => @post.id).first
    
    if user_post.nil?
      user_post= UserPost.new(:post => @post, :website => @website, :current_page => 1)
      current_user.user_posts.push(user_post)
    end
    
    respond_with @post, current_page: user_post.current_page, :root => "posts"
  end


  private  
    def set_post
      @post = Post.find(params[:id])
    end
    
    def set_website
      @website = Website.find(params[:website_id])
    end
end
