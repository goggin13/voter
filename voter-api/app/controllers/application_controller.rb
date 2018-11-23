class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :set_session_id
  before_action :set_current_user

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
    @current_user = User.find_or_create_by(:name => @session_id).tap do |user|
      Rails.logger.info "[Session] current user #{user.inspect}"
    end
  end
end
