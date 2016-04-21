class AssignmentsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index, :show]
  before_action :find_classroom

  def index
    @class_room = ClassRoom.includes(:user_classes, assignments: [assignment_submits: :user]).
      find_by_id params[:class_room_id]
    if check_lecturer_of_class? current_user, @class_room.user_classes
      @assignment = @class_room.assignments.new if current_user.lecturer?
    elsif is_member_of_class? current_user, @class_room.user_classes
      @assignment_submit = @class_room.assignment_submits.new
    else
      redirect_to @class_room
    end
    @assignments = @class_room.assignments
  end

  def create
    if @assignment.save
      EventService.new(current_user.id, @assignment, params[:action]).save
      @class_room = @assignment.class_room
      redirect_to [@class_room, @assignment]
    else
      render :new
    end
  end

  def show
    @assignment = Assignment.includes(assignment_submits: :user).find params[:id]
  end

  def new

  end

  def edit

  end

  def update
    if @assignment.update_attributes assignment_params
      EventService.new(current_user.id, @assignment, params[:action]).save
      @class_room = @assignment.class_room
      redirect_to [@class_room, @assignment]
    else
      render :edit
    end
  end

  def destroy
    @assignment.destroy
    redirect_to class_room_assignments_path @class_room
  end

  private
  def assignment_params
    params.require(:assignment).permit Assignment::ATTRIBUTES_PARAMS
  end

  def find_classroom
    @class_room = ClassRoom.includes(:user_classes, assignments: [assignment_submits: :user]).
      find_by_id params[:class_room_id]

    unless @class_room
      flash[:dander] = t "flashs.messages.model_not_found",
        model: "ClassRoom", id: params[:class_room_id]
      redirect_to class_rooms_path
    end
  end
end
