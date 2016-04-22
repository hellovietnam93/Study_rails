class VerificationsController < ApplicationController
  def new
    if current_user.verified?
      flash[:notice] = t "flashs.messages.verified"
      redirect_to current_user
    end
  end

  def create
    temp_user = PrimeUser.find_by_uid params[:uid]
    if temp_user
      current_user.profile.update_attributes uid: temp_user.uid, birthday: temp_user.birthday,
        program: temp_user.program, class_name: temp_user.class_name, cohort: temp_user.cohort,
        status: temp_user.status
      current_user.update_attributes username: "#{temp_user.first_name} #{temp_user.middle_name} #{temp_user.last_name}",
        verified: true
    end

    redirect_to current_user
  end
end
