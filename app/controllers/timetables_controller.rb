class TimetablesController < ApplicationController
  load_and_authorize_resource

  def index
    @class_room = ClassRoom.includes(:timetables, course: [:syllabus_details],
      user_classes: :user).find params[:class_room_id]
    @timetable = Timetable.new
    @timetables = @class_room.timetables
    load_syllabus_details
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end
  end

  def create
    check_class_status
    @timetable.save
    EventService.new(current_user.id, @timetable).save
    redirect_to class_room_timetables_path @timetable.class_room
  end

  def edit
    check_class_status
    load_syllabus_details
    respond_to do |format|
      format.js
    end
  end

  def update
    check_class_status
    @timetable.update timetable_params
    EventService.new(current_user.id, @timetable).save
    redirect_to class_room_timetables_path @timetable.class_room
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  private
  def timetable_params
    params.require(:timetable).permit :class_room_id, :title,
      :time_start, :time_end, :content, syllabus_detail_ids: []
  end

  def load_syllabus_details
    @syllabus_details = []
    @class_room.course.syllabuses.each do |syllabus|
      @syllabus_details += syllabus.syllabus_details
    end
  end

  def check_class_status
    @class_room = @timetable.class_room
    if @class_room.closed?
      flash[:dander] = t "flashs.messages.closed", classroom: @class_room.uid
      redirect_to class_rooms_path
    end
  end
end
