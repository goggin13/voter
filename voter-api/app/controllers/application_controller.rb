class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :set_session_id
  before_action :set_current_user
  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers

  def heartbeat
    render json: {}
  end

  def set_session_id
    @session_id = cookies[:session_id] || params[:session_id]
    if @session_id.nil?
      @session_id = SecureRandom.hex(8)
      Rails.logger.info "[Session] generating new session id #{@session_id}"
      response.set_cookie(:session_id, @session_id)
    else
      Rails.logger.info "[Session] found session id #{@session_id}"
    end
  end

  def set_current_user
    @current_user = User.find_or_create_by(:session_id => @session_id).tap do |user|
      Rails.logger.info "[Session] current user #{user.inspect}"
    end
  end

  def current_user
    @current_user
  end

  def cors_set_access_control_headers
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = "POST, PUT, DELETE, GET, OPTIONS"
    headers["Access-Control-Allow-Headers"] = "*"
    headers["Access-Control-Max-Age"] = "1728000"
    headers["Access-Control-Allow-Credentials"] = "true"
  end

  def cors_preflight_check
    return unless request.method == :options
    render :text => "", :content_type => "text/plain"
  end
end
