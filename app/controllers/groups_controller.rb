class GroupsController < ApplicationController
  load_and_authorize_resource
  skip_load_and_authorize_resource only: :show

  def show
    @group = Group.includes(group_users: :user).find params[:id]
    @members = @group.group_users.select do |group_user|
      group_user.status == "take_in"
    end

    @requests = @group.group_users.select do |group_user|
      group_user.status == "waiting"
    end
    @group_user = @group.group_users.new
  end

  def create
    @group.save
    init_manager_group
    redirect_to @group, notice: flash_message("created")
  end

  def update
    @group.update_attributes group_params
    redirect_to @group, notice: flash_message("updated")
  end

  private
  def group_params
    params.require(:group).permit :name, :picture, :permisson
  end

  def init_manager_group
    current_user.group_users.create group: @group, manager: true, status: 1
  end
end
