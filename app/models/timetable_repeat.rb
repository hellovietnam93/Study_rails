class TimetableRepeat < ActiveRecord::Base
  belongs_to :timetable

  enum repeat_type: [:every_day, :every_week, :every_month, :all_day_in_week]
  enum repeat_on: [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
  enum end_type: [:none_end, :after_times, :end_in_day]
end
