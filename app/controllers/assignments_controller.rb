class AssignmentsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:index, :show]
  before_action :find_classroom
  before_action :check_class_status, except: [:index, :show]

  def index
    if check_lecturer_of_class? current_user, @class_room.user_classes
      @assignment = @class_room.assignments.new if current_user.lecturer?
    elsif is_member_of_class? current_user, @class_room.user_classes
      @assignment_submit = @class_room.assignment_submits.new
    else
      redirect_to @class_room
    end
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end

    @assignments = @class_room.assignments
  end

  def create
    if @assignment.save
      EventService.new(current_user.id, @assignment, params[:action]).save
      NotifyService.new(@assignment).assignment_notify
      @class_room = @assignment.class_room
      redirect_to [@class_room, @assignment]
    else
      render :new
    end
  end

  def show
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end
    @assignment = Assignment.includes(assignment_submits: :user).find params[:id]
    @number_submited_students = AssignmentSubmit.find_submitted_students(@assignment.start_time,
      @assignment.end_time).size
    @percent_submited_student = eval "@number_submited_students / @class_room.user_classes.size * 100"
  end

  def new
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end
  end

  def edit
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end
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
    @class_room = ClassRoom.includes(user_classes: [:user], assignments: [assignment_submits: :user]).
      find_by_id params[:class_room_id]

    unless @class_room
      flash[:dander] = t "flashs.messages.model_not_found",
        model: "ClassRoom", id: params[:class_room_id]
      redirect_to class_rooms_path
    end
  end

  def check_class_status
    if @class_room.closed?
      flash[:dander] = t "flashs.messages.closed", classroom: @class_room.uid
      redirect_to class_rooms_path
    end
  end
end
