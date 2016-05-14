class ClassRoomsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :show

  def index

  end

  def show
    @class_room = ClassRoom.includes(course: [:course_references], user_classes: :user).find params[:id]
    @members = @class_room.user_classes.select do |user_class|
      !user_class.owner && user_class.status == "take_in"
    end
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end
    @user_class = @class_room.user_classes.new
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
    if params[:class_room][:questions_attributes].blank?
      redirect_to @class_room
    else
      redirect_to class_room_questions_path @class_room
    end
  end

  private
  def class_room_params
    params.require(:class_room).permit ClassRoom::ATTRIBUTES_PARAMS
  end
end
