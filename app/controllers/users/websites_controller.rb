class Users::WebsitesController < Users::ApplicationController
  before_filter :authenticate_user!
  respond_to :json
  
  def index
    params[:page] ||= 1
    params[:per] ||= 50
    websites = current_user.websites.page(params[:page]).per(params[:per])
    
    respond_with websites
  end
  
  def create
    website = Website.find(params[:website_id])
    current_user.websites.push(website)
    render :status => 201, nothing: true
  end
end
