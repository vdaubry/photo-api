class Api::V1::Users::SessionsController < Devise::SessionsController  
  respond_to :json

  def create
    if params[:users].nil?  || params[:users][:email].nil?  || params[:users][:password].nil?
      return render :status => 422, :json => {:error => "Missing user email and/or password"}
    end

    user = User.where(:email => params[:users][:email]).first

    if user && user.valid_password?(params[:users][:password])
      user.assign_authentication_token!
      render :status => 200, :json => {:users => {:token => user.authentication_token, :id => user.id.to_s}}
    else 
      render :status => 400, :json => {:error => "invalid credentials : unknown email or wrong password"}
    end
  end
end
