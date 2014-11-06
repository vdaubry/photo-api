class PostImagesController < ApplicationController
  respond_to :json

  def index
    respond_with current_api_user.user_websites.find(params[:user_website_id]).website_posts.find(params[:website_post_id]).post_images
  end
end