class SyllabusDetail < ActiveRecord::Base
  belongs_to :syllabus

  has_many :timetable_details, dependent: :destroy
end
