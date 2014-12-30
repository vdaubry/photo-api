class Api::V1::BaseController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :authenticate_user_from_token!
  skip_before_filter :verify_authenticity_token
  
  def ping
    website = Website.first

    if website
      render :status => 200, :text => 'ok'
    else
      render :status => 404, :text => 'not found'
    end
  end

  def render_404
    render :status => 404, :text => 'not found'
  end
  
   private
  
  def authenticate_user_from_token!
    if params[:authentication_token]
      user = User.where(:authentication_token => params[:authentication_token]).first
      
      puts "user = #{user}"
      
      sign_in user, store: false if user.present?
    end
  end
end
