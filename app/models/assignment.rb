class Assignment < ActiveRecord::Base
  attr_accessor :action, :controller
  belongs_to :class_room

  ATTRIBUTES_PARAMS = [:name, :class_room_id, :content, :start_date, :end_date, :assignment_type]

  enum assignment_type: [:single, :multiple]
end
