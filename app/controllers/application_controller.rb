class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_filter :verify_authenticity_token

  def ping
    render :status => 404, :text => 'ok'
  end

  def render_404
    render :status => 404, :text => 'not found'
  end
end
