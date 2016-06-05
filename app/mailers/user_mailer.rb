class UserMailer < ApplicationMailer
  def assign_class user, class_room
    @user = user
    @class_room = class_room

    mail to: @user.email, subject: I18n.t("mailers.subjects.assign_class")
  end

  def timetable_notification user, class_room, timetable
    @user = user
    @class_room = class_room
    @timetable  = timetable

    mail to: @user.email, subject: I18n.t("mailers.subjects.start_lesson")
  end

  def assignment_start student, assignment
    @student = student
    @assignment = assignment

    mail to: @student.email, subject: I18n.t("mailers.subjects.assigment_start")
  end

  def assignment_deadline student, assignment
    @student = User.find student
    @assignment = assignment

    mail to: @student.email, subject: I18n.t("mailers.subjects.assignment_deadline")
  end
end
