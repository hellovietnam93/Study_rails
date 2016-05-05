class AssignmentSubmit < ActiveRecord::Base
  has_many :assignment_histories, dependent: :destroy

  belongs_to :user
  belongs_to :class_room
  belongs_to :assignment
  belongs_to :team

  ATTRIBUTES_PARAMS = [:content, :class_room_id, :user_id, :assignment_id,
    :policy, :title, :score, :team_id]

  enum policy: [:share_with_everyone, :share_with_team, :share_with_lecturer]

  scope :find_submitted_students, ->start_time, end_time{where "updated_at BETWEEN
    ? AND ?", start_time, end_time}

  validates :title, presence: true
  validate :has_team?
  validate :over_range_of_mark

  private
  def has_team?
    if share_with_team? && !user.has_team_in_class?(class_room)
      errors.add :base, I18n.t("flashs.messages.do_not_have_team", class_room: class_room.uid)
    end
  end

  def over_range_of_mark
    if score.present? and (score < 0 or score > 10)
      errors.add :base, I18n.t("flashs.messages.over_range_of_score")
    end
  end
end
