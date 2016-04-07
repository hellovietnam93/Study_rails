class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.lecturer?
      can :manage, Question
      can [:index, :show], Semester
      can [:index, :update, :show], ClassRoom
      can :manage, Assignment
      can [:create, :destroy], UserClass
      can [:index, :show], AssignmentSubmit
      can :manage, AssignmentHistory
      can :manage, Forum
      can :manage, Post, user_id: user.id
      can :manage, Comment, user_id: user.id
      can [:create, :destroy], Like, user_id: user.id
      can :manage, Document, user_id: user.id
      can :manage, Timetable
      can :manage, User, id: user.id
      can [:index, :show, :edit, :update, :destroy], Team, Team do |team|
        user.class_room_ids.include? team.class_room_id
      end
      can [:new, :create], Team
      can :manage, ClassTeam
    else
      can :index, Assignment
      can [:index, :show], ClassRoom
      can [:create, :destroy], UserClass, user_id: user.id
      can :show, Assignment
      can :manage, AssignmentSubmit, user_id: user.id
      can :read, Forum
      can :manage, Post, user_id: user.id
      can :manage, Comment, user_id: user.id
      can [:create, :destroy], Like, user_id: user.id
      can :index, Document
      can :index, Timetable
      can :manage, User, id: user.id
      can [:index, :show], Team, Team do |team|
        user.class_room_ids.include? team.class_room_id
      end
      can :destroy, ClassTeam, user_id: user.id
    end

    can [:create, :update], Group, Group.includes(:group_users) do |group|
      group.group_users.find do |group_user|
        group_user.manager && group_user.user_id == user.id
      end
    end
  end
end
