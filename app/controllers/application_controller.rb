class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :authenticate_user!, :set_locale
  before_action :verify_namespace, if: :user_signed_in?
  before_action :verify_user, if: :user_signed_in?

  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_path
  end

  def default_url_options options = {}
    {locale: I18n.locale}
  end

  protected
  def after_sign_in_path_for user
    if user.admin?
      admin_root_path
    else
      user.verified? ? root_path : new_verification_path
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def verify_namespace
    @namespace = controller_path.split("/").first

    if @namespace != "sessions"
      if @namespace == "admin" && !current_user.admin?
        redirect_to root_path
        flash[:alert] = t "flashs.messages.permission_denied"
      elsif @namespace != "admin" && current_user.admin?
        redirect_to admin_root_path
        flash[:alert] = t "flashs.messages.permission_denied"
      end
    end
  end

  def verify_user
    if !current_user.admin? && !current_user.verified? &&
      @namespace != "sessions" && params[:controller] != "verifications"
      redirect_to new_verification_path
    end
  end
end
