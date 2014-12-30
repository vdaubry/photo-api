class Api::V1::WebsitesController < Api::V1::ApplicationController
  respond_to :json
  
  def index
    params[:page] ||= 1
    params[:per] ||= 50
    websites = Website.all.page(params[:page]).per(params[:per])
    respond_with websites
  end


  # def search
  #   websites = Website.where(:url => params[:url])
  #   respond_with websites
  # end
end
