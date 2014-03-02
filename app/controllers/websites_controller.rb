class WebsitesController < ApplicationController
  respond_to :json
  
  def index
    respond_with Website.all
  end

  def search
    websites = Website.where(:url => params[:url])
    respond_with websites
  end
end
