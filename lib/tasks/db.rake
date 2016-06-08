namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Importing prime user"
    import = ImportService.new "#{Rails.root}/lib/assets/59.csv", PrimeUser, ["uid"], "prime_user"
    import.save! if import.valid?

    puts "Creating User"
    user = User.create email: "hellovietnam93@gmail.com", password: "12345678", password_confirmation: "12345678",
      role: 0, username: "Admintrator"
    user.create_profile

    user = User.create email: "tungtung12543@gmail.com", password: "12345678", password_confirmation: "12345678",
      role: 1, username: "Nguyen Tien Trung", verified: true
    user.create_profile

    5.times do |n|
      user = User.create email: "teacher_#{n}@gmail.com", password: "12345678", password_confirmation: "12345678",
        role: 1, username: "Teacher #{n}", verified: true
      user.create_profile
    end

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
    Semester.create name: "20161", start_date: "20160601".to_date, end_date: "20161001".to_date

    puts "Import course"
    ReadDocService.new "lib/assets/Cac He Phan Tan 12.1.2015.doc", Course.new
    ReadDocService.new "lib/assets/Cong nghe Web va Dich vu truc tuyen 12.1.2015.doc", Course.new
    ReadDocService.new "lib/assets/CTDT2009-CSDL.doc", Course.new
    ReadDocService.new "lib/assets/CTDT2009-He tri thuc-12_Jan_2015.doc", Course.new

    20.times do |n|
      Course.create name: "Subject_#{n}", uid: "IT334#{4 + n}", description: "2",
        theory_duration: 2, exercise_duration: 2, practice_duration: 2, weight: 2, evaluation: "2"
    end

    puts "Create ClassRoom"
    class_room_params = {uid: "123456", name: "Hệ phân tán", max_student: 45, status: :open,
      class_type: :theory, semester_id: 2, start_date: "2016/01/01",
      end_date: "2016/05/31", description: "11111111111111111111",
      teacher: "tungtung12543@gmail.com", course_id: 1,
      title: "", date_start: "", time_start: "10:30 AM", date_end: "",
      time_end: "11:30 AM", full_day: 0, repeat: 1,
      repeat_type: "every_week", repeat_on: "monday",
      range: "", day_start: "2016/01/01", end_type: "none_end"}

    new_class_form = NewClassFrom.new
    new_class_form.submit class_room_params
    ClassRoom.first.create_forum

    course_ids = [1, 2, 3, 4]
    hours = [7, 8, 9, 10]
    10.times do |n|
      course_id = course_ids.sample
      hour = hours.sample
      class_room_params = {uid: "44444#{5 + n}", name: "#{Course.find(course_id).name} #{n}",
        max_student: 45, status: :open,
        class_type: :theory, semester_id: 3, start_date: "2016/06/01",
        end_date: "2016/09/30", description: "11111111111111111111",
        teacher: User.lecturer.map(&:email).sample, course_id: course_id,
        title: "", date_start: "", time_start: "#{hour}:30 AM", date_end: "",
        time_end: "#{hour + 1}:30 AM", full_day: 0, repeat: 1,
        repeat_type: "every_week", repeat_on: TimetableRepeat.repeat_ons.keys.sample,
        range: "", day_start: "2016/06/01", end_type: "none_end"}
      new_class_form = NewClassFrom.new
      new_class_form.submit class_room_params

      ClassRoom.last.create_forum
    end

    puts "Update manager"
    UserClass.first.update status: 1

    puts "Add member to classroom"
    User.student.where("id < 30").each do |user|
      user.user_classes.create class_room: ClassRoom.first, status: 1
    end

    User.student.where("id < 40 AND id > 31").each do |user|
      user.user_classes.create class_room: ClassRoom.first, status: 0
    end

    Rake::Task["db:create_post"].invoke
    Rake::Task["db:create_assignment"].invoke
    Rake::Task["db:create_reminder"].invoke

    puts "Completed rake data"
  end
end
