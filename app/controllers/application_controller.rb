class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :verify_namespace, if: :user_signed_in?

  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_path
  end

  protected
  def after_sign_in_path_for user
    if user.admin?
      admin_root_path
    else
      root_path
    end
  end

  def verify_namespace
    namespace = controller_path.split("/").first

    if namespace != "devise"
      if namespace == "admin" && !current_user.admin?
        redirect_to root_path
        flash[:alert] = t "flashs.messages.permission_denied"
      elsif namespace != "admin" && current_user.admin?
        redirect_to admin_root_path
        flash[:alert] = t "flashs.messages.permission_denied"
      end
    end
  end
end
