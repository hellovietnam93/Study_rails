class ClassRoomsController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show
    @members = @class_room.user_classes.where owner: false
    @questions = @class_room.questions
    @user_class = @class_room.user_classes.new
    @assignment = @class_room.assignments.new
      question = @class_room.questions.build
      4.times { question.answers.build }
  end

  def update
    @class_room.update_attributes class_room_params
    redirect_to @class_room
  end

  private
  def class_room_params
    params.require(:class_room).permit ClassRoom::ATTRIBUTES_PARAMS
  end
end
