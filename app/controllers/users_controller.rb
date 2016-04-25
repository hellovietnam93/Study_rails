class UsersController < ApplicationController
  authorize_resource
  before_action :find_user

  def show
    @timetables = Timetable.where class_room_id: @user.class_room_ids
    @total_courses = @user.class_rooms.pluck(:course_id).uniq.count
    @total_current_classes = @user.class_rooms.where(semester_id: Semester.last.id).count
    @edit_user_form = EditUserForm.new @user
  end

  def update
    @edit_user_form = EditUserForm.new @user
    if @edit_user_form.submit user_params
      redirect_to @user
    else
      render :show
    end
  end

  private
  def find_user
    @user = User.includes(class_rooms: :course).find_by_id params[:id]
  end

  def user_params
    params.require(:user).permit :username, :email, :password, :passoword_confirmation,
      :school, :cohort, :program, :class_name, :uid, :birthday, :address, :phone
  end
end
