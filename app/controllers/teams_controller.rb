class TeamsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index
  before_action :find_class_room

  def index
    if check_lecturer_of_class?(current_user, @class_room.user_classes) ||
      is_member_of_class?(current_user, @class_room.user_classes)
      @teams = @class_room.teams
      find_request
    else
      redirect_to @class_room
    end
  end

  def new
    if check_lecturer_of_class? current_user, @class_room.user_classes
      find_members
      find_request
      @team = @class_room.teams.new
    else
      redirect_to @class_room
    end
  end

  def create
    if @team.save
      flash[:success] = flash_message "created"
      EventService.new(current_user.id, @team).save
      redirect_to class_room_team_path @class_room, @team
    else
      flash[:failed] = flash_message "not created"
      find_members
      render :new
    end
  end

  def show
    @posts = @team.posts.order updated_at: :desc
    @post = @team.posts.build
    @comment = current_user.comments.build
    @assignment_submits = AssignmentSubmit.share_with_team.where user_id: @team.user_ids
    find_request
  end

  def edit
    find_members
    find_request
  end

  def update
    if @team.update_attributes team_params
      flash[:success] = flash_message "updated"
      redirect_to class_room_team_path @class_room, @team
    else
      flash[:failed] = flash_message "not updated"
      find_members
      render :edit
    end
  end

  def destroy
    if @team.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not deleted"
    end
    redirect_to class_room_teams_path @class_room
  end

  private
  def team_params
    params[:team][:user_ids] << current_user.id
    params.require(:team).permit Team::ATTRIBUTES_PARAMS
  end

  def find_class_room
    @class_room = ClassRoom.includes(teams: [:class_teams], user_classes: [:user]).
      find_by_id params[:class_room_id]
    unless @class_room
      flash[:dander] = t "flashs.messages.model_not_found",
        model: "ClassRoom", id: params[:class_room_id]
      redirect_to class_rooms_path
    end
  end

  def has_team? user_class
    @class_room.teams.find do |team|
      return team.user_ids.include? user_class.user_id
    end
  end

  def find_members
    @members = []
    @class_room.user_classes.where(owner: false).each do |user_class|
      @members << user_class.user if user_class.take_in? && !has_team?(user_class)
    end

    if params[:action] == "edit" || params[:action] == "update"
      @team.users.each do |user|
        unless @class_room.user_classes.find {|user_class| user_class.owner && user_class.user_id == user.id}
          @members << user
        end
      end
    end
  end

  def find_request
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end
  end
end
