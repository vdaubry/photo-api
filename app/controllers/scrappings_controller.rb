class ScrappingsController < ApplicationController
  before_action :set_website, only: [:create]

  respond_to :json

  def create
    scrapping = @website.scrappings.create(:date => params[:scrapping][:date])
    respond_with scrapping do |format|
      format.json { render json: scrapping }
    end
    
  end

  private

  def set_website
    @website = Website.find(params[:website_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:scrapping).permit(:date, :duration, :image_count, :success)
  end

end