class Question < ActiveRecord::Base
  belongs_to :class_room
  belongs_to :course

  has_many :answers, dependent: :destroy
  has_many :online_tests, dependent: :destroy
  has_many :results, dependent: :destroy

  accepts_nested_attributes_for :answers, reject_if: lambda {|a| a[:content].blank?},
    allow_destroy: true

  enum question_type: [:single, :multiple, :fill_in_blank]
  enum priority: [:high, :medium, :low, :extra]

  private
  CSV_REJECT_ATTRIBUTES = ["id", "class_room_id", "course_id", "created_at", "updated_at"]
end
