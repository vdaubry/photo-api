class ZipfilesController < ApplicationController
  respond_to :json

  def index
    respond_with Zipfile.all
  end
end
