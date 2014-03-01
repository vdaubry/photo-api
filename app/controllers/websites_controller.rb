class WebsitesController < ApplicationController
  respond_to :json
  
  def index
    respond_with Website.all
  end

  def search
    website = Website.where(:url => params[:url]).first
    respond_with website
  end
end
