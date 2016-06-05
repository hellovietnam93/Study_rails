class UserClassesController < ApplicationController
  load_and_authorize_resource
  before_action :load_class_room, only: :create

  def create
    if right_key? params[:user_class][:key]
      enroll_class current_user
      NotifyService.new(@user_class).perform
      redirect_to @class_room
    else
      @user_class.errors.add :base, I18n.t("class_rooms.user_classes.key_not_right")
      render "class_rooms/_sign_in_class_modal"
    end
  end

  def destroy
    @class_room = @user_class.class_room
    if @user_class.destroy
      sub_registered_student unless @user_class.owner
    end
    redirect_to @class_room
  end

  private
  def user_class_params
    params.require(:user_class).permit [:key, :class_room_id]
  end

  def load_class_room
    @class_room = ClassRoom.includes(:user_classes).find_by id:
      params[:user_class][:class_room_id]
  end

  def right_key? enroll_key
    enroll_key == (current_user.lecturer? ? @class_room.enroll_key : @class_room.student_key)
  end

  def enroll_class current_user
    if current_user.lecturer?
      @user_class = UserClass.find_by user_id: current_user.id, class_room_id: @class_room.id,
        owner: true
      if @user_class
        @user_class.update_attributes status: 1
      else
        flash[:alert] = t "flashs.messages.not_right_teacher"
      end
    elsif current_user.student?
      @user_class.update_attributes user: current_user, status: 1
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
