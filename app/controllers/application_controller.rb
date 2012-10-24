class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!
  
protected

  def ensure_admin_logged_in!
    if basic_authenticated? && !current_user.admin?
      redirect_to(expositions_path, :alert => "Acceso denegado!")
      false
    end
  end
  
  def basic_authenticate
    authenticate_or_request_with_http_basic do |user, passwd|
      success = user == Conf.admin['user'] && passwd == Conf.admin['passwd']
      current_user.update_attribute(:admin, true) if success && current_user && !current_user.admin?
      success
    end
  end

private
  
  def basic_authenticated?
    basic_authenticate != 401
  end
end
