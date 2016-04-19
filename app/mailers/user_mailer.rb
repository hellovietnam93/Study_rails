class UserMailer < ApplicationMailer
  def assign_class user, class_room
    @user = user
    @class_room = class_room

    mail to: @user.email, subject: I18n.t("mailers.subjects.assign_class")
  end
end
