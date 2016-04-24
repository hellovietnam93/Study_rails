class MarksController < ApplicationController

  def update
    @assignment_submits = AssignmentSubmit.find params[:id]
    @assignment_submits.update_attributes assignment_submit_params
    redirect_to :back
  end

  private
  def assignment_submit_params
    params.require(:assignment_submit).permit AssignmentSubmit::ATTRIBUTES_PARAMS
  end
end
