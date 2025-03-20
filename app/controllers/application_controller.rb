class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protected

  def after_update_path_for(resource)
    profile_path
  end

  rescue_from ActionController::UnknownFormat do
    redirect_to root_path(format: :html)
  end
end
