class Admin::SyllabusesController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource
  skip_load_resource only: [:create]

  def new
    @syllabus = @course.syllabuses.build
    @syllabus.syllabus_details.build

    @syllabus_form = SyllabusForm.new @syllabus
  end

  def create
    @syllabus = @course.syllabuses.build

    params[:syllabus][:syllabus_details_attributes].each do |_, value|
      @syllabus.syllabus_details.build
    end

    @syllabus_form = SyllabusForm.new @syllabus
    if @syllabus_form.validate params[:syllabus].permit!
      @syllabus_form.save
      flash[:notice] = flash_message "created"
      redirect_to params.has_key?("continue") ? new_admin_course_syllabus_path(@course) : [:admin, @course]
    else
      flash[:alert] = flash_message "not_created"
      render :new
    end
  end

  def edit
    @syllabus_form = SyllabusForm.new @syllabus
  end

  def update
    @syllabus_form = SyllabusForm.new @syllabus

    if @syllabus_form.validate params[:syllabus].permit!
      @syllabus_form.save
      flash[:notice] = flash_message "updated"
      redirect_to [:admin, @course]
    else
      flash[:alert] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @syllabus.destroy
      flash[:notice] = flash_message "deleted"
    else
      flash[:alert] = flash_message "not_deleted"
    end
    redirect_to [:admin, @course]
  end
end
