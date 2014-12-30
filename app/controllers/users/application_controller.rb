class Users::ApplicationController < ApplicationController
  before_filter :authenticate_user_from_token!
  
  private
  
    def authenticate_user_from_token!
      if params[:authentication_token]
        user = User.where(:authentication_token => params[:authentication_token]).first
        
        puts "user = #{user}"
        
        sign_in user, store: false if user.present?
      end
    end
end
