class WebsitesController < ApplicationController
  respond_to :json
  
  def index
    respond_with Website.all
  end
end
