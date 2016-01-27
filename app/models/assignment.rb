class Assignment < ActiveRecord::Base
  has_many :assignment_submits, dependent: :destroy
  has_many :assignment_histories, dependent: :destroy

  belongs_to :class_room

  ATTRIBUTES_PARAMS = [:name, :class_room_id, :content, :start_date, :end_date, :assignment_type]

  enum assignment_type: [:single, :multiple]
end
