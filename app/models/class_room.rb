class ClassRoom < ActiveRecord::Base
  attr_accessor :teacher

  has_many :user_classes
  has_many :users, through: :user_classes
  has_many :assignments, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :online_tests, dependent: :destroy
  has_many :assignment_submits, dependent: :destroy
  has_many :assignment_histories, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :timetables, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :reminders, as: :reminderable

  has_one :forum, dependent: :destroy

  belongs_to :course
  belongs_to :semester
  belongs_to :reminderable, polymorphic: true

  STATUSES = {open: :open, in_progress: :in_progress, pending: :pending, closed: :closed}
  enum status: STATUSES.values
  enum class_type: [:theory, :pratice, :experiment]

  accepts_nested_attributes_for :questions, reject_if: lambda {|a| a[:name].blank?},
    allow_destroy: true

  ATTRIBUTES_PARAMS = [:name, :uid, :description, :course_id, :semester_id, :enroll_key, :end_date,
    :class_type, :max_student, :registered_student, :status, :student_key, :teacher, :start_date,
    questions_attributes: [:id, :name, :question_type, :priority, :course_id, :_destroy,
    answers_attributes: [:id, :content, :correct, :_destroy]]]

  validates :uid, presence: true, length: {maximum: 10, minimum: 4}
  validates :name, presence: true, length: {maximum: 255, minimum: 10}
  validates :description, presence: true, length: {minimum: 4}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :max_student, presence: true

  def lecturer
    user_classes.find_by owner: true
  end

  def students
    user_classes.where owner: false, status: 1
  end
end
