class TimetableNotifyWorker < Struct.new :user, :class_room, :timetable
  include Sidekiq::Worker
  def perform
    UserMailer.timetable_notification(user, class_room, timetable).deliver
    class_room.reminders.create(user_id: user.id, occur_date: timetable.time_start,
      remind_type: :start_lesson)
  end
end
