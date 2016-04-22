class UsersController < ApplicationController
  authorize_resource
  before_action :find_user

  def show
    @timetables = Timetable.where class_room_id: @user.class_room_ids
    @total_courses = @user.class_rooms.pluck(:course_id).uniq.count
    @total_current_classes = @user.class_rooms.where(semester_id: Semester.last.id).count
  end

  private
  def find_user
    @user = User.includes(class_rooms: :course).find_by_id params[:id]
  end
end
