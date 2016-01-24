class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.lecturer?
      can [:index, :show], Semester
      can [:index, :show], ClassRoom
      can :manage, Assignment
      can [:create, :destroy], UserClass
    else
      can [:index, :show], ClassRoom
      can [:create, :destroy], UserClass
      can :show, Assignment
    end
  end
end
