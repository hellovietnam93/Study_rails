class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :authenticate_user!

  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_path
  end

  protected
  def verify_admin
    unless current_user.admin?
      flash[:danger] = t "flashs.messages.permission_denied"
      redirect_to root_path
    end
  end
end
