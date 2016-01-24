class ClassRoom < ActiveRecord::Base
  has_many :user_classes
  has_many :users, through: :user_classes
  has_many :group_classes, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :online_tests, dependent: :destroy

  belongs_to :course
  belongs_to :semester

  STATUSES = {open: :open, in_progress: :in_progress, pending: :pending, closed: :closed}
  enum status: STATUSES.values
  enum class_type: [:theory, :pratice, :experiment]

  ATTRIBUTES_PARAMS = [:name, :uid, :description, :course_id, :semester_id, :enroll_key,
    :class_type, :max_student, :registered_student, :status]

  def lecturer
    user_classes.find_by owner: true
  end

  def students
    user_classes.where owner: false
  end
end
