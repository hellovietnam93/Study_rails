class TimetableRepeat < ActiveRecord::Base
  belongs_to :timetable

  enum repeat_type: [:every_day, :every_week, :every_month, :all_day_in_week]
  enum repeat_on: [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
end
