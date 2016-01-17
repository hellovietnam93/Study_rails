class Course < ActiveRecord::Base
  has_many :class_rooms, dependent: :destroy

  accepts_nested_attributes_for :class_rooms

  ATTRIBUTES_PARAMS = [:name, :uid, :description, :credit, :credit_fee, :theory_duration,
    :exercise_duration, :practice_duration, :weight, :en_name, :abbr_name, :language,
    :evaluation, class_room_attributes: [:name, :uid, :description, :course_id,
    :semester_id, :enroll_key, :class_type, :max_student, :registered_student, :status]
  ]
end
