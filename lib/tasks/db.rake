namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Creating User"
    user = User.create email: "hellovietnam93@gmail.com", password: "12345678", password_confirmation: "12345678",
      role: 0, username: "Admintrator"
    user.create_profile

    user = User.create email: "tungtung12543@gmail.com", password: "12345678", password_confirmation: "12345678",
      role: 1, username: "Nguyen Tien Trung", verified: true
    user.create_profile

    user = User.create email: "giant_panda93@yahoo.com.vn", password: "12345678", password_confirmation: "12345678",
      role: 2, username: "Panda", verified: true
    user.create_profile

    50.times do |n|
      user = User.create email: "email_#{n}@gmail.com", username: "User_#{n}", password: "12345678",
        password_confirmation: "12345678", role: 2
      user.create_profile
    end

    puts "Create Semester"
    Semester.create name: "20151", start_date: "20150801".to_date, end_date: "20151231".to_date
    Semester.create name: "20152", start_date: "20160101".to_date, end_date: "20160601".to_date

    puts "Create Course"
    Course.create name: "Database", uid: "IT3344", description: "2", base_hours: 15,
      theory_duration: 2, exercise_duration: 1, practice_duration: 0, weight: 2, evaluation: "2"
    9.times do |n|
      syllabus = Syllabus.create course_id: 1, title: "Syllabus #{n}", week: n
      3.times do |m|
        syllabus.syllabus_details.create course_id: 1, title: "SyllabusDetail #{m} of Syllabus #{n}"
      end
    end

    10.times do |n|
      Course.create name: "Subject_#{n}", uid: "IT334#{4 + n}", description: "2",
      theory_duration: 2, exercise_duration: 2, practice_duration: 2, weight: 2, evaluation: "2"
    end

    puts "Create ClassRoom"
    classroom = ClassRoom.create name: "Database", uid: "444444", description: "1111111111",
      course_id: 1, semester_id: 2, enroll_key: SecureRandom.base64, student_key: SecureRandom.base64,
      class_type: 0, max_student: 22, status: 0
    classroom.create_forum


    10.times do |n|
      a = ClassRoom.create name: "Database_#{n}", uid: "44444#{4 + n}", description: "1111111111",
        course_id: 1, semester_id: 2, enroll_key: SecureRandom.base64, student_key: SecureRandom.base64,
        class_type: 0, max_student: 22, status: 0
      a.create_forum
    end

    puts "Add member to classroom"
    UserClass.create user: User.second, class_room: ClassRoom.first, status: 1,
      owner: true

    User.student.where("id < 30").each do |user|
      user.user_classes.create class_room: ClassRoom.first, status: 1
    end

    5.times do |n|
      post = Post.create name: "Post number #{n}", content: "Content of post #{n}",
        user_id: ClassRoom.first.user_ids.sample, class_room_id: 1
      post.update_attributes postable: ClassRoom.first.forum
      5.times do |m|
        post.comments.create content: "New comment #{m}", user_id: ClassRoom.first.user_ids.sample
      end
    end

    User.student.where("id < 40 AND id > 31").each do |user|
      user.user_classes.create class_room: ClassRoom.first, status: 0
    end

    puts "Create Assignment"
    3.times do |n|
      Assignment.create name: "Assignment_#{n}", assignment_type: 0,
        start_time: Time.now + n.day, end_time: Time.now + (2 +n).day,
        content: "Content of assignment #{n}", class_room_id: 1
    end

    puts "Completed rake data"
  end
end
