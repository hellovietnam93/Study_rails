class Admin::ClassRoomsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :course
  before_action :load_data, only: [:new, :edit]

  def index
    @class_rooms = @course.class_rooms
  end

  def new
    @new_class_form = NewClassFrom.new
  end

  def create
    @new_class_form = NewClassFrom.new
    if @new_class_form.submit params[:class_room]
      redirect_to admin_course_class_rooms_path @course
    else
      flash[:alert] = flash_message "not_created"
      load_data
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update
    if @class_room.update_attributes class_room_params
      flash[:notice] = flash_message [:updated]
      redirect_to admin_course_path course
    else
      flash[:alert] = flash_message "not_updated"
      load_data
      render :edit
    end
  end

  def destroy
    @class_room.destroy
    flash[:notice] = flash_message "deleted"
    redirect_to admin_course_path @course
  end

  private
  def class_room_params
    params.require(:class_room).permit ClassRoom::ATTRIBUTES_PARAMS
  end

  def load_data
    @semesters = Semester.all.order name: :asc
  end
end
