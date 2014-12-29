class WebsitesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json
  
  def index
    params[:page] ||= 1
    params[:per] ||= 50
    if params[:user_id]
      websites = current_user.websites.page(params[:page]).per(params[:per])
    else
      websites = Website.all.page(params[:page]).per(params[:per])
    end
    respond_with websites
  end
  
  def create
    website = Website.find(params[:website_id])
    current_user.websites.push(website)
    render :status => 201, nothing: true
  end

  # def search
  #   websites = Website.where(:url => params[:url])
  #   respond_with websites
  # end
end
