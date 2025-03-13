class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protected

  def after_update_path_for(resource)
    profile_path
  end
end
