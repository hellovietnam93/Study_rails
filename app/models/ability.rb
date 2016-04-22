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
      can :manage, Post, Post do |post|
        (post.user_id == user.id) || (post.class_room.user_classes.find_by user_id: user.id, owner: true)
      end
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
      can :update, EventUser, user_id: user.id
    else
      can :index, Assignment
      can [:index, :show], ClassRoom
      can [:create, :destroy], UserClass, user_id: user.id
      can :show, Assignment
      can [:index, :show], AssignmentSubmit, AssignmentSubmit do |assignment_submit|
        case assignment_submit.policy
        when "share_with_everyone"
          assignment_submit.class_room.user_ids.include? user.id
        when "share_with_team"
          assignment_submit.user.teams.find_by(class_room_id: assignment_submit.class_room_id).
            user_ids.include? user.id
        when "share_with_lecturer"
          (assignment_submit.user_id == user.id) ||
            (assignment_submit.class_room.user_classes.find_by owner: true, user_id: user.id)
        end
      end
      can [:update, :edit, :destroy], AssignmentSubmit, AssignmentSubmit do |assignment_submit|
        case assignment_submit.policy
        when "share_with_everyone"
          assignment_submit.user_id == user.id
        when "share_with_team"
          assignment_submit.user.teams.find_by(class_room_id: assignment_submit.class_room_id).
            user_ids.include? user.id
        when "share_with_lecturer"
          (assignment_submit.user_id == user.id) ||
            (assignment_submit.class_room.user_classes.find_by owner: true, user_id: user.id)
        end
      end
      can [:create, :new], AssignmentSubmit
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
      can :update, EventUser, user_id: user.id
    end

    can [:create, :update], Group, Group.includes(:group_users) do |group|
      group.group_users.find do |group_user|
        group_user.manager && group_user.user_id == user.id
      end
    end
  end
end
