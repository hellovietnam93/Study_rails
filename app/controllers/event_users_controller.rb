class EventUsersController < ApplicationController
  load_and_authorize_resource

  def update
    respond_to do |format|
      @event_user.update_attributes status: :seen
      format.js
    end
  end
end
