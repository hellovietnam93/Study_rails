class AssignmentHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :class_room
  belongs_to :assignment
  belongs_to :assignment_submit
  belongs_to :team
end
