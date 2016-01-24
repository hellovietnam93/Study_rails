class AssignmentsController < ApplicationController
  load_and_authorize_resource

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
