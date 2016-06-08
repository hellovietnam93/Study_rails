namespace :db do
  desc "Create assignments"
  task create_assignment: :environment do
    puts "Create assignments"
    classroom = ClassRoom.first
    5.times do |n|
      assignment = Assignment.create name: "Assignment_#{n}",
        start_time: classroom.start_date + (n + 1).day, end_time: classroom.start_date + (3 +n).day,
        content: "Content of assignment #{n}", class_room_id: classroom.id
      NotifyService.new(assignment).update_assignment_status
    end

    scores = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10]
    ClassRoom.first.assignments.each do |assignment|
      ClassRoom.first.user_classes.take_in.each do |user_class|
        if user_class.user.student?
          assignment.reminders.create user_id: user_class.user_id, remind_type: :start_submit,
            occur_date: assignment.start_time.to_date, created_at: (assignment.start_time - 1.day)

          assignment.reminders.create user_id: user_class.user_id, remind_type: :deadline,
            occur_date: assignment.end_time.to_date, created_at: (assignment.end_time - 1.day)

          submission = assignment.assignment_submits.create user_id: user_class.user_id, class_room_id: classroom.id,
            title: "Submit of user #{user_class.user.email}", content: "Hello", policy: 2,
            score: scores.sample

          submission.assignment_histories.create user_id: submission.user_id,
            class_room_id: submission.class_room_id, content: submission.content,
            team_id: submission.team_id, title: submission.title
        end
      end
    end

    puts "Completed rake data"
  end
end
