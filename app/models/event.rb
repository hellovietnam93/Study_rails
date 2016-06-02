class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :class_room

  has_many :event_users, dependent: :destroy

  enum event_type: [:timetable, :new_assignment, :edit_assignment,
    :new_assignment_submit, :edit_assignment_submit, :document, :new_class_assign,
    :new_team, :new_post, :new_comment_post, :new_comment_comment]
end
