class Course < ActiveRecord::Base
  has_many :class_rooms, dependent: :destroy

  extend FriendlyId
  friendly_id :uid, use: [:slugged, :finders]

  ATTRIBUTES_PARAMS = [:name, :uid, :description, :credit, :credit_fee, :theory_duration,
    :exercise_duration, :practice_duration, :weight, :en_name, :abbr_name, :language,
    :evaluation]
end
