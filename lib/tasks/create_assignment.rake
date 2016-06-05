namespace :db do
  desc "Create assignments"
  task create_assignment: :environment do
    puts "Create assignments"
    classroom = ClassRoom.first
    10.times do |n|
      Assignment.create name: "Assignment_#{n}",
        start_time: classroom.start_date + n.day, end_time: classroom.start_date + (2 +n).day,
        content: "Content of assignment #{n}", class_room_id: classroom.id
    end

    scores = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10]
    ClassRoom.first.assignments.each do |assignment|
      ClassRoom.first.user_classes.take_in.each do |user_class|
        if user_class.user.student?
          assignment.assignment_submits.create user_id: user_class.user_id, class_room_id: classroom.id,
            title: "Submit of user #{user_class.user.email}", content: "Hello", policy: 2,
            score: scores.sample
        end
      end
    end

    puts "Completed rake data"
  end
end
