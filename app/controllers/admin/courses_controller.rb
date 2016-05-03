class Admin::CoursesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:show, :create]

  def index
    @courses = @courses.order uid: :asc
  end

  def new
    course_reference = @course.course_references.build
    syllabus = @course.syllabuses.build
    syllabus_detail = syllabus.syllabus_details.build

    @course_form = CourseForm.new @course
  end

  def create
    @course = Course.new
    params[:course][:course_references_attributes].each do |_, value|
      @course.course_references.build
    end

    @course_form = CourseForm.new @course
    if @course_form.validate params[:course].permit!
      @course_form.save
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
    @course_form = CourseForm.new @course
  end

  def update
    @course_form = CourseForm.new @course

    if @course_form.validate params[:course].permit!
      @course_form.save
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
end
