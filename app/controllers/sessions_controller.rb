class SessionsController < Devise::SessionsController
  layout "blank"

  def new
    super
  end
end
