class TimetablesController < ApplicationController
  load_and_authorize_resource

  def index
    @class_room = ClassRoom.includes(:timetables).find params[:class_room_id]
    @timetable = Timetable.new
    @timetables = @class_room.timetables
  end

  def create
    @timetable.save
    EventService.new(current_user.id, @timetable).save
    redirect_to class_room_timetables_path @timetable.class_room
  end

  def update
    respond_to do |format|
      if @timetable.update timetable_params
        EventService.new(current_user.id, @timetable).save
        format.json {render :index, location: @timetable.class_room }
      else
        format.json {render json: @timetable.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def timetable_params
    params.require(:timetable).permit :class_room_id, :title,
      :start_time, :end_time, :content
  end
end
