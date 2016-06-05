namespace :db do
  desc "Create reminders"
  task create_reminder: :environment do
    puts "Create reminders"
    ClassRoom.first.timetables.each do |timetable|
      ClassRoom.first.user_classes.take_in.each do |user_class|
        ClassRoom.first.reminders.create user_id: user_class.user_id, remind_type: 0,
          occur_date: timetable.time_start, created_at: timetable.time_start - 1.day
      end
    end
  end
end
