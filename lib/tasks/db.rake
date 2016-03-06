namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Creating User"
    User.create email: "hellovietnam93@gmail.com", password: "12345678", password_confirmation: "12345678",
      role: 0
    User.create email: "tungtung12543@gmail.com", password: "12345678", password_confirmation: "12345678",
      role: 1
    User.create email: "gaint_panda93@yahoo.com.vn", password: "12345678", password_confirmation: "12345678",
      role: 2
    puts "Completed rake data"
  end
end
