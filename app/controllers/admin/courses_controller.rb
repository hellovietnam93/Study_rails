class Admin::CoursesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :show

  def index
    @courses = @courses.order uid: :asc
  end

  def new

  end

  def create
    if @course.save
      flash[:notice] = flash_message "created"
      redirect_to [:admin, @course]
    else
      flash[:alert] = flash_message "not_created"
      render :new
    end
  end

  def show
    @course = Course.includes(:class_rooms, syllabuses: :syllabus_details).find params[:id]
    @syllabuses = @course.syllabuses
    @semesters = Semester.all.order name: :asc
    @class_rooms = @course.class_rooms
  end

  def edit

  end

  def update
    if @course.update_attributes course_params
      flash[:notice] = flash_message "updated"
      redirect_to [:admin, @course]
    else
      flash[:alert] = flash_message "not_updated"
      render :edit
    end

  end

  def destroy
    @course.destroy
    flash[:notice] = flash_message "deleted"
    redirect_to admin_coures_path
  end

  private
  def course_params
    params.require(:course).permit Course::ATTRIBUTES_PARAMS
  end
end
