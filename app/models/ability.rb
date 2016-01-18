class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.lecturer?
      can :manage, ClassRoom
      cannot :destroy, ClassRoom
      can [:create, :destroy], UserClass
    else
      can [:index, :show], ClassRoom
      can [:create, :destroy], UserClass
    end
  end
end
