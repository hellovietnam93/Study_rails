class SyllabusDetail < ActiveRecord::Base
  belongs_to :syllabus
  belongs_to :course

  has_many :timetable_details, dependent: :destroy
  has_many :timetables, through: :timetable_details
end
