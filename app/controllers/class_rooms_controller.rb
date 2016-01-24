class ClassRoomsController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show
    @members = @class_room.user_classes.where owner: false
    @user_class = @class_room.user_classes.new
    @assignment = @class_room.assignments.new
  end
end
