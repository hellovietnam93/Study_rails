class CoursesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :show

  def index

  end

  def show
    @course = Course.includes(:class_rooms).find_by_id params[:id]
    @class_rooms = @course.class_rooms
  end
end
