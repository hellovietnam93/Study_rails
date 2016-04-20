class Timetable < ActiveRecord::Base
  belongs_to :class_room

  has_many :timetable_details, dependent: :destroy
  has_many :syllabus_details, through: :timetable_details
end
