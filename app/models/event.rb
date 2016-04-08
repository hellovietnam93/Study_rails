class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :class_room

  has_many :event_users, dependent: :destroy

  enum event_type: [:timetable, :new_assignment, :edit_assignment,
    :new_assignment_submit, :new_member, :remove_member, :new_document,
    :new_team, :out_team]
end
