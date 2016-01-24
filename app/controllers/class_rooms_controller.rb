class ClassRoomsController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show
    @members = @class_room.user_classes.where owner: false
    @questions = @class_room.questions
    @user_class = @class_room.user_classes.new
    @assignment = @class_room.assignments.new
  end

  def update
    if params[:class_room]
      if @class_room.update_attributes class_room_params
        flash[:notice] = flash_message "updated"
      else
        flash[:alert] = flash_message "not_updated"
      end
    else
      flash[:alert] = flash_message "not_updated"
    end
    redirect_to @class_room
  end

  private
  def class_room_params
    params.require(:class_room).permit ClassRoom::ATTRIBUTES_PARAMS
  end
end
