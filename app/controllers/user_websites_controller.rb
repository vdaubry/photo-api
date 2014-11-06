class UserWebsitesController < ApplicationController
  respond_to :json

  def index
    respond_with current_api_user.user_websites.all
  end
end
