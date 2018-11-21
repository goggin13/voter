class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :set_current_user

  def set_current_user
    #@current_user = User.find_or_create(params[:session_id])
  end
end
