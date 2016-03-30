class ClassRoom < ActiveRecord::Base
  has_many :user_classes
  has_many :users, through: :user_classes
  has_many :assignments, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :online_tests, dependent: :destroy
  has_many :assignment_submits, dependent: :destroy
  has_many :assignment_histories, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :timetables, dependent: :destroy

  has_one :forum, dependent: :destroy

  belongs_to :course
  belongs_to :semester

  STATUSES = {open: :open, in_progress: :in_progress, pending: :pending, closed: :closed}
  enum status: STATUSES.values
  enum class_type: [:theory, :pratice, :experiment]

  accepts_nested_attributes_for :questions, reject_if: lambda {|a| a[:name].blank?},
    allow_destroy: true

  ATTRIBUTES_PARAMS = [:name, :uid, :description, :course_id, :semester_id, :enroll_key,
    :class_type, :max_student, :registered_student, :status,
    questions_attributes: [:id, :name, :question_type, :priority, :course_id, :_destroy,
    answers_attributes: [:id, :content, :correct, :_destroy]]]

  def lecturer
    user_classes.find_by owner: true
  end

  def students
    user_classes.where owner: false, status: 1
  end
end
