namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Creating User"
    User.create email: "hellovietnam93@gmail.com", password: "12345678", password_confirmation: "12345678",
      role: 0, username: "Admintrator"
    User.create email: "tungtung12543@gmail.com", password: "12345678", password_confirmation: "12345678",
      role: 1, username: "Nguyen Tien Trung"
    User.create email: "giant_panda93@yahoo.com.vn", password: "12345678", password_confirmation: "12345678",
      role: 2, username: "Panda"

    Semester.create name: "20151A", start_date: "20160101".to_date, end_date: "20160501".to_date
    Course.create name: "Database", uid: "IT3344", description: "2", credit: 2, credit_fee: 2, theory_duration: 2, exercise_duration: 2, practice_duration: 2, weight: 2, en_name: "DB", abbr_name: "2", language: "English", evaluation: "2"
    ClassRoom.create name: "Database", uid: "444444", description: "1111111111",
      course_id: 1, semester_id: 1, enroll_key: "PwN1fR5X1yFxaFlZzzICRg==",
      class_type: 0, max_student: 22, status: 0

    puts "Completed rake data"
  end
end
