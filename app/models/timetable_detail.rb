class TimetableDetail < ActiveRecord::Base
  belongs_to :timetable
  belongs_to :syllabus_detail
end
