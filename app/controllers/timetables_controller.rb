class TimetablesController < ApplicationController
  def index
    @class_room = ClassRoom.includes(:timetables).find params[:class_room_id]
    @timetable = Timetable.new
    @timetables = @class_room.timetables
  end

  def create
    @timetable = Timetable.new timetable_params
    @timetable.save
    redirect_to class_room_timetables_path @timetable.class_room
  end

  def update
    @timetable = Timetable.find params[:id]
    respond_to do |format|
      if @timetable.update timetable_params
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
