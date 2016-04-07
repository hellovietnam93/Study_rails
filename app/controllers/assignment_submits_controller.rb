class AssignmentSubmitsController < ApplicationController
  load_and_authorize_resource

  def show

  end

  def create
    respond_to do |format|
      @assignment_service = AssignmentSubmitService.new @assignment_submit
      reload_assignment_submits if @assignment_service.save
      format.js
    end
  end

  def update
    respond_to do |format|
      params[:assignment_submit][:user_id] = @assignment_submit.user_id
      @assignment_service = AssignmentSubmitService.new @assignment_submit, assignment_submit_params
      reload_assignment_submits if @assignment_service.update current_user
      format.js
    end
  end

  def destroy
    respond_to do |format|
      @assignment_service = AssignmentSubmitService.new @assignment_submit
      reload_assignment_submits if @assignment_service.destroy
      format.js
    end
  end

  private
  def assignment_submit_params
    params.require(:assignment_submit).permit AssignmentSubmit::ATTRIBUTES_PARAMS
  end

  def reload_assignment_submits
    @assignment_submits = @assignment_submit.assignment.assignment_submits
  end
end
