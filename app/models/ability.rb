class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.lecturer?
      can [:create, :update, :destroy], Question
      can [:index, :show], Semester
      can [:index, :update, :show], ClassRoom
      can :manage, Assignment
      can [:create, :destroy], UserClass
      can [:index, :show], AssignmentSubmit
      can :manage, AssignmentHistory
    else
      can [:index, :show], ClassRoom
      can [:create, :destroy], UserClass, user_id: user.id
      can :show, Assignment
      can :manage, AssignmentSubmit, user_id: user.id
    end
  end
end
