class EventUsersController < ApplicationController
  load_and_authorize_resource

  def update
    @event_user.update_attributes status: :seen
    case @event_user.event.event_type
    when "new_class_assign"
      redirect_to @event_user.event.class_room
    when "timetable"
      redirect_to class_room_timetables_path @event_user.event.class_room
    when "document"
      redirect_to class_room_documents_path @event_user.event.class_room
    when "new_assignment", "edit_assignment"
      redirect_to [@event_user.event.class_room, Assignment.find(@event_user.event.target_id)]
    when "new_assignment_submit", "edit_assignment_submit"
      assignment_submit = AssignmentSubmit.find @event_user.event.target_id
      redirect_to [assignment_submit.assignment, assignment_submit]
    when "new_post", "new_comment_post", "new_comment_comment"
      post = Post.find @event_user.event.target_id
      redirect_to [post.postable, post]
    else
      redirect_to :back
    end
  end
end
