class TokensController < ApplicationController

  respond_to :json

  def create
    if params[:user].nil?  || params[:user][:email].nil?  || params[:user][:password].nil?
      return render :status => 422, :json => {:error => "Missing user email and/or password"}
    end

    user = User.where(:email => params[:user][:email]).first

    if user && user.valid_password?(params[:user][:password])
      user.assign_authentication_token!
      render :status => 200, :json => {:token => user.authentication_token}
    else 
      render :status => 400, :json => {:error => "invalid credentials : unknown email or wrong password"}
    end
  end
end