class RegistrationsController < Devise::RegistrationsController
  layout "blank"

  def new
    super
  end
end
