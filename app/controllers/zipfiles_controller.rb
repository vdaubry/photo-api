class ZipfilesController < ApplicationController
  respond_to :json

  def index
    Zipfile.where(:created_at.lte => 1.day.ago).destroy_all
    respond_with Zipfile.all
  end
end
