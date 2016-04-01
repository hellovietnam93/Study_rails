class AssignmentsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index

  def index
    @class_room = ClassRoom.includes(:user_classes, assignments: [assignment_submits: :user]).
      find_by_id params[:class_room_id]
    if @class_room
      if check_lecturer_of_class? current_user, @class_room.user_classes
        @assignment = @class_room.assignments.new if current_user.lecturer?
      elsif is_member_of_class? current_user, @class_room.user_classes
        @assignment_submit = @class_room.assignment_submits.new
      else
        redirect_to @class_room
      end
      @assignments = @class_room.assignments
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
