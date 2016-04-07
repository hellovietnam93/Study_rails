class AssignmentSubmit < ActiveRecord::Base
  has_many :assignment_histories, dependent: :destroy

  belongs_to :user
  belongs_to :class_room
  belongs_to :assignment

  ATTRIBUTES_PARAMS = [:content, :class_room_id, :user_id, :assignment_id]

  enum policy: [:share_with_everyone, :share_with_team, :share_with_lecturer]
end
