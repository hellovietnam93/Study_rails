class MyDocumentsController < ApplicationController
  def index
    if current_user.lecturer?
      @documents = current_user.documents
      @assignments = []
      current_user.class_rooms.each do |class_room|
        @assignments += class_room.assignments
      end
    else
      @assignment_submits = []
      current_user.class_rooms.each do |class_room|
        team_id = (current_user.team_ids & class_room.team_ids).first
        class_room.assignment_submits.each do |assignment_submit|
          if (assignment_submit.team_id.present? && assignment_submit.team_id == team_id) || (assignment_submit.team_id.nil? assignment_submit.user_id == current_user.id)
            @assignment_submits += assignment_submit.assignment_histories
          end
        end
      end
    end
  end
end
