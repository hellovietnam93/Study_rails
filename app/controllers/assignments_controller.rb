class AssignmentsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index

  def index
    @class_room = ClassRoom.includes(:assignments, :assignment_submits).
      find_by_id params[:class_room_id]
    if @class_room
      @assignment = @class_room.assignments.new if current_user.lecturer?
      @assignments = @class_room.assignments
      @assignment_submit = @class_room.assignment_submits.new if current_user.student?
    else
      flash[:dander] = t "flashs.messages.model_not_found",
        model: "ClassRoom", id: params[:class_room_id]
    end
  end

  def create
    respond_to do |format|
      if @assignment.save
        @class_room = @assignment.class_room
      end
      format.js
    end
  end

  def show

  end

  def update
    respond_to do |format|
      if @assignment.update_attributes assignment_params
        @class_room = @assignment.class_room
        @assignments = @class_room.assignments
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      @assignment.destroy
      format.js
    end
  end

  private
  def assignment_params
    params.require(:assignment).permit Assignment::ATTRIBUTES_PARAMS
  end
end
