class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    binding.pry
    if user.admin?
      can :manage, :all
    else
      cannot :manage, Import
    end
  end
end
