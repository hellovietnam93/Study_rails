class UserClassesController < ApplicationController
  load_and_authorize_resource
  before_action :load_class_room, only: :create

  def create
    respond_to do |format|
      if right_key? params[:user_class][:key]
        enroll_class current_user
        @assignment = @class_room.assignments.new
      else
        @user_class.errors.add :base, I18n.t("class_rooms.user_classes.key_not_right")
      end
      format.js
    end
  end

  def destroy
    @class_room = @user_class.class_room
    respond_to do |format|
      if @user_class.destroy
        sub_registered_student
      end
      format.js
    end
  end

  private
  def user_class_params
    params.require(:user_class).permit [:key, :class_room_id]
  end

  def load_class_room
    @class_room = ClassRoom.find_by id: params[:user_class][:class_room_id]
  end

  def right_key? enroll_key
    enroll_key == @class_room.enroll_key
  end

  def enroll_class current_user
    if current_user.lecturer?
      @user_class.update_attributes user: current_user, owner: true
    elsif current_user.student?
      @user_class.update_attributes user: current_user
      add_registered_student
    end
  end

  def add_registered_student
    student_number = if @class_room.registered_student.nil?
      1
    else
      @class_room.registered_student + 1
    end
    @class_room.update_attributes registered_student: student_number
  end

  def sub_registered_student
    student_number = @class_room.registered_student - 1
    @class_room.update_attributes registered_student: student_number
  end
end
