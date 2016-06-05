class AssignmentNotifyWorker < Struct.new :student, :assignment, :reminder_type
  include Sidekiq::Worker
  def perform
    if reminder_type == Settings.reminders.start_submit
      UserMailer.assignment_start(student, assignment).deliver
      assignment.reminders.create(user_id: student.id, occur_date: assignment.start_time,
        remind_type: :start_submit)
    elsif reminder_type == Settings.reminders.deadline
      UserMailer.assignment_deadline(student, assignment).deliver
      assignment.reminders.create(user_id: student.id, occur_date: assignment.end_time,
        remind_type: :deadline)
    end
  end
end
