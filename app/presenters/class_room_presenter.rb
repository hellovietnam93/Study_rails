class ClassRoomPresenter < BasePresenter
  presenters :class_room

  def display user
    @user = user
    if has_lecturer? && @user.lecturer? && is_lecturer_of_class?
      render "class_rooms/nav_tabs"
    elsif @user.student? && is_member_of_class?
      render "students/class_rooms/nav_tabs"
    else
      render "class_rooms/sign_in_class_modal"
    end
  end

  private
  def user_classes
    class_room.user_classes
  end

  def has_lecturer?
    user_classes.map(&:owner).include? true
  end

  def is_lecturer_of_class?
    user_classes.map(&:user_id).include? @user.id
  end

  def is_member_of_class?
    user_classes.find do |user_class|
      user_class.status == "take_in" && user_class.user_id == @user.id
    end
  end
end
