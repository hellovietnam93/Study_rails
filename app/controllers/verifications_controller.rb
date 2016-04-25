class VerificationsController < ApplicationController
  def new
    if current_user.verified?
      flash[:notice] = t "flashs.messages.verified"
      redirect_to current_user
    end
  end

  def create
    if params.has_key? "skip"
      current_user.update_attributes verified: true, role: 2
      redirect_to current_user
    else
      temp_user = PrimeUser.find_by_uid params[:uid]
      if temp_user
        if params[:role] == "lecturer"
          current_user.update_attributes username: "#{temp_user.first_name} #{temp_user.middle_name} #{temp_user.last_name}",
            verified: true, role: 1
        else
          current_user.update_attributes username: "#{temp_user.first_name} #{temp_user.middle_name} #{temp_user.last_name}",
            verified: true
        end
      else
        render :new
        flash[:alert] = t "flashs.messages.not_found", uid: params[:uid]
      end
    end
  end

  private
  def update_profile
    current_user.profile.update_attributes uid: temp_user.uid, birthday: temp_user.birthday,
      program: temp_user.program, class_name: temp_user.class_name, cohort: temp_user.cohort,
      status: temp_user.status
    flash[:notice] = t "flashs.messages.updated", model_name: Profile
    redirect_to current_user
  end
end
