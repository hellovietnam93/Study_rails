class ClassRoomRequestsController < ApplicationController
  before_action :find_user_class, only: [:destroy, :update]

  def create
    @class_room = ClassRoom.find params[:class_room_id]
    current_user.user_classes.create class_room: @class_room, status: 0
    redirect_to @class_room
  end

  def update
    @user_class.update_attributes status: 1
    NotifyService.new(@user_class).perform
    redirect_to @user_class.class_room
  end

  def destroy
    @user_class.destroy
    redirect_to @user_class.class_room
  end

  private
  def find_user_class
    @user_class = UserClass.find params[:id]
  end
end
