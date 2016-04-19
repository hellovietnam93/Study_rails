class Admin::ClassRoomsController < ApplicationController
  load_and_authorize_resource

  def index
    @courses = Course.all.order name: :asc
    @semesters = Semester.all.order name: :asc
    @class_room = ClassRoom.new
  end

  def new

  end

  def create
    @class_room_service = ClassRoomService.new @class_room, class_room_params[:teacher]
    respond_to do |format|
      if @class_room_service.save
        @class_room.create_forum
        @class_rooms = @class_room.course.class_rooms
      end
      format.js
    end
  end

  def show

  end

  def edit
    @semesters = Semester.all.order name: :asc
    @course = @class_room.course
    @courses = Course.all.order uid: :asc
    respond_to do |format|
      format.js
    end
  end

  def update
    respond_to do |format|
      if @class_room.update_attributes class_room_params
        @course = @class_room.course
        @class_rooms = @course.class_rooms
      end
      format.js
    end
  end

  def destroy
    @course = @class_room.course
    respond_to do |format|
      if @class_room.destroy
        @class_rooms = @course.class_rooms
      end
      format.js
    end
  end

  private
  def class_room_params
    params.require(:class_room).permit ClassRoom::ATTRIBUTES_PARAMS
  end
end
