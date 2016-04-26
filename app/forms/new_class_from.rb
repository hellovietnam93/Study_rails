class NewClassFrom
  def initialize

  end

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  class << self
    def model_name
      ActiveModel::Name.new self, nil, ClassRoom.name
    end
  end

  validate :course_not_found
  validate :must_belongs_to_time_of_semester
  validate :start_date_must_smaller_than_end_date
  validate :start_time_must_smaller_than_end_time
  validate :must_belongs_to_time_of_class
  validate :not_enough_time_to_learn_course
  validate :must_smaller_than_total_hours_of_syllabus

  attr_accessor :teacher
  delegate :name, :uid, :description, :course_id, :semester_id, :enroll_key,
    :class_type, :max_student, :status, :end_date, :start_date, to: :class_room
  delegate :date_start, :date_end, :title, :content, :repeat, :time_start,
    :time_end, :full_day, to: :timetable
  delegate :repeat_on, :repeat_type, :range, :day_start, to: :timetable_repeat

  def class_room
    @class_room ||= ClassRoom.new
  end

  def timetable
    @timetable ||= class_room.timetables.new
  end

  def timetable_repeat
    @timetable_repeat ||= timetable.timetable_repeats.new
  end

  def submit params
    params.permit!
    @course = Course.includes(syllabuses: :syllabus_details).find_by params[:course_id]

    class_room.attributes = params.slice :name, :uid, :description, :course_id, :semester_id, :enroll_key,
      :class_type, :max_student, :status, :end_date, :start_date
    timetable.attributes = params.slice :date_start, :date_end, :title, :content, :repeat, :time_start,
      :time_end, :full_day
    timetable_repeat.attributes = params.slice :repeat_on, :repeat_type, :range, :day_start
    @semester = class_room.semester

    if valid?
      class_room_service = ClassRoomService.new class_room, params[:teacher]
      class_room_service.save
      class_room.create_forum
      timetable.save!
      timetable_repeat.save!
      true
    else
      false
    end
  end

  private
  def not_enough_time_to_learn_course
    @range_days = class_room.end_date - class_room.start_date
    if @range_days * 24 < @course.total_hours
      errors.add :not_enough_time, "Not enough time"
    elsif timetable.repeat? && @range_days / 7 < timetable_repeat.range
      errors.add :week_is_over, "Week is over"
    end
  end

  def must_smaller_than_total_hours_of_syllabus
    range_hours = (timetable.start_time - timetable.end_time) / 60 / 60
    if timetable.repeat?
      case timetable_repeat.repeat_type
      when "every_day"
        if range_hours * timetable_repeat.range * 5 > @course.total_hours
          errors.add :long_time, "Long time"
        end
      when "every_week"
        if range_hours * timetable_repeat.range > @course.total_hours
          errors.add :long_time, "Long time"
        end
      when "every_month"
        if range_hours * ((class_room.end_date.year * 12 + class_room.end_date.month) - (class_room.start_date.year * 12 + class_room.start_date.month)) > @course.total_hours

        end
      when "all_day_in_week"
        if range_hours * timetable_repeat.range * 7 > @course.total_hours
          errors.add :long_time, "Long time"
        end
      end
    else
      if range_hours > @course.total_hours
        errors.add :not_valid_time, "Errors time"
      end
    end
  end

  def must_belongs_to_time_of_semester
    unless (@semester.start_date <= class_room.start_date && @semester.end_date >= class_room.end_date)
      errors.add :base, "Don't belong to time of class"
    end
  end

  def start_date_must_smaller_than_end_date
    if class_room.start_date > class_room.end_date
      errors.add :base, "start date greater than end date"
    end
  end

  def start_time_must_smaller_than_end_time
    if timetable.start_time >timetable.end_time
      errors.add :base, "start time greater than end time"
    end
  end

  def must_belongs_to_time_of_class
    unless (class_room.start_date <= timetable.start_time && class_room.end_date >= timetable.end_time)
      errors.add :base, "Don't belong to time of class"
    end
  end

  def course_not_found
    errors.add :course, "Not fournd" unless @course
  end
end
