class ClassRoomsController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def new

  end

  def create

  end

  def show
    @students = @class_room.user_classes.where owner: false
    @user_class = @class_room.user_classes.new
  end

  def edit

  end

  def update

  end
end
