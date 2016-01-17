class Admin::CoursesController < ApplicationController
  load_and_authorize_resource

  def index
    @courses = @courses.order uid: :asc
    @course = Course.new
  end

  def new

  end

  def create
    respond_to do |format|
      if @course.save
        list_all_courses
      end
      format.js
    end
  end

  def show
    @semesters = Semester.all.order name: :asc
    @class_rooms = @course.class_rooms
    @class_room = @class_rooms.build
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    respond_to do |format|
      if @course.update_attributes course_params
        list_all_courses
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @course.destroy
        list_all_courses
      end
      format.js
    end
  end

  private
  def course_params
    params.require(:course).permit Course::ATTRIBUTES_PARAMS
  end

  def list_all_courses
    @courses = Course.all.order name: :asc
  end
end
