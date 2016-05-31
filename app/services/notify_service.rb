class NotifyService
  def initialize object
    @object = object
  end

  def perform
    send_notify_user_classes if @object.take_in?
  end

  def assignment_notify
    send_notify_assignment
  end

  private
  def send_notify_user_classes
    @object.class_room.timetables.each do |timetable|
      time = timetable.time_start - Settings.numbers.one.days

      Delayed::Job.enqueue(TimetableNotifyWorker.new(@object.user,
        @object.class_room, timetable), 0, time)
    end
  end

  def send_notify_assignment
    @object.class_room.students.each do |student|
      start_time = @object.start_time - Settings.numbers.one.days
      end_time = @object.end_time - Settings.numbers.one.days

      Delayed::Job.enqueue(AssignmentNotifyWorker.new(student.user,
        @object, Settings.reminders.start_submit), 0, start_time)

      Delayed::Job.enqueue(AssignmentNotifyWorker.new(student.user,
        @object, Settings.reminders.deadline), 0, end_time)
    end
  end
end
