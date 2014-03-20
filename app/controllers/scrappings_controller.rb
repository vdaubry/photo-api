class ScrappingsController < ApplicationController
  before_action :set_website, only: [:create, :update]
  before_action :set_scrapping, only: [:update]

  respond_to :json

  def create
    scrapping = @website.scrappings.create(:date => params[:scrapping][:date])
    respond_with scrapping do |format|
      format.json { render json: scrapping }
    end
  end

  def update
    @scrapping.update_attributes(post_params)

    if @scrapping.success
      @scrapping.image_count = @scrapping.posts.inject(0) {|val,post| val += post.images.to_sort.count }
      @scrapping.save
    end

    respond_with @scrapping do |format|
      format.json { render json: @scrapping }
    end
  end

  private

  def set_website
    @website = Website.find(params[:website_id])
  end

  def set_scrapping
    @scrapping = @website.scrappings.find(params[:id])
  end  

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:scrapping).permit(:date, :duration, :image_count, :success)
  end

end