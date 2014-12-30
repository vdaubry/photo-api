class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    user = User.new(post_params)

    if user.save
      user.assign_authentication_token!
      render :status => 200, :json => {:token => user.authentication_token}
    else
      render :status => 400, :json => {:error => user.errors.full_messages}
    end
  end
  
  private
  def post_params
    params.require(:users).permit(:email, :password, :password_confirmation)
  end
end
