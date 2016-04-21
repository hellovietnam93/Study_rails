class AssignmentSubmitsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :create
  load_and_authorize_resource :assignment

  def show

  end

  def new
    if @assignment.start_time > Time.now
      flash[:alert] = t "assignment_submits.errors.not_time_to_submit_assignment",
        title: @assignment.name
      redirect_to class_room_assignments_path @assignment.class_room
    elsif @assignment.end_time > Time.now
      flash[:alert] = t "assignment_submits.errors.late_to_submit"
    end
  end

  def edit

  end

  def create
    params[:assignment_submit][:class_room_id] = @assignment.class_room_id
    params[:assignment_submit][:assignment_id] = @assignment.id
    params[:assignment_submit][:user_id] = current_user.id
    @assignment_submit = AssignmentSubmit.new assignment_submit_params

    @assignment_service = AssignmentSubmitService.new @assignment_submit
    if @assignment_service.save
      flash[:notice] = flash_message "created"
      redirect_to class_room_assignment_path @assignment.class_room, @assignment
    else
      flash[:alert] = flash_message "not_created"
      render :new
    end
  end

  def update
    params[:assignment_submit][:user_id] = @assignment_submit.user_id
    @assignment_service = AssignmentSubmitService.new @assignment_submit, assignment_submit_params
    if @assignment_service.update current_user
      flash[:notice] = flash_message "updated"
      redirect_to class_room_assignment_path @assignment.class_room, @assignment
    else
      flash[:alert] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    @assignment_service = AssignmentSubmitService.new @assignment_submit
    @assignment_service.destroy
    redirect_to class_room_assignments_path @assignment.class_room
  end

  private
  def assignment_submit_params
    params.require(:assignment_submit).permit AssignmentSubmit::ATTRIBUTES_PARAMS
  end
end
