class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_filter :verify_authenticity_token
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers
  
  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.
  #cf http://tuts.syrinxoon.net/tuts/configurer-rails-4-pour-le-cors
  def cors_preflight_check
      if request.method == "OPTIONS"
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] =  %w{GET POST PUT DELETE}.join(",")
        headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
        headers['Access-Control-Max-Age'] = '1728000'
        render :text => '', :content_type => 'text/xml'
      end
  end

  # Return the CORS access control headers.
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = %w{GET POST PUT DELETE}.join(",")
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def options
    head(:ok)
  end

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
end
