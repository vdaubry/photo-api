class Api::V1::Users::PostsController < Api::V1::Users::BaseController
  before_filter :authenticate_user!
  before_action :set_website, only: [:index, :show]
  before_action :set_post, only: [:show]
  
  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound, :with => :render_404

  def index
    params[:page] ||= 1
    params[:per] ||= 50
    respond_with @website.posts.desc(:updated_at).page(params[:page]).per(params[:per])
  end
  
  def show
    current_page = UserPost.getCurrentPage(current_user, @post)
    respond_with @post, current_page: current_page, :root => "posts"
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
