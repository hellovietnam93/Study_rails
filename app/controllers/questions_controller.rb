class QuestionsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index
  before_action :load_class_room
  before_action :init_message, only: :create

  def index
    if @class_room
      redirect_to @class_room unless user_in_class? current_user, @class_room
      @questions = @class_room.questions
    else
      flash[:dander] = t "flashs.messages.model_not_found",
        model: "ClassRoom", id: params[:class_room_id]
    end
  end

  def create
    if params[:type].present?
      params[:type].each_with_index do |data_type, index|
        import = ImportService.new "#{params[:file][index].tempfile.path.to_s}",
          find_model(data_type).constantize, find_verify_attribute(data_type), data_type,
          @class_room, @class_room.course
        if import.valid?
          import.save! ? @notice << data_type.gsub("_", " ").capitalize.pluralize :
            @alert << data_type.gsub("_", " ").capitalize.pluralize
        else
          @alert << data_type.gsub("_", " ").capitalize.pluralize
        end
      end
      redirect_to class_room_questions_path(@class_room), notice: flash_message("import.success", @notice),
        alert: flash_message("import.alert", @alert)
    else
      redirect_to class_room_questions_path(@class_room), alert: flash_message("import.no_select_file")
    end
  end

  private
  def load_class_room
    @class_room = ClassRoom.includes(:course, :questions).find params[:class_room_id]
  end

  def init_message
    @notice = Array.new
    @alert = Array.new
  end

  def find_model data_type
    data_type.split("_").each {|word| word.capitalize!}.join("")
  end

  def find_verify_attribute model
    Settings.reload!
    Settings.imports.data_types.detect{|data_type| data_type.model == model}.verify_attributes
  end
end
