class DocumentsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index
  before_action :find_class_room

  def index
    load_documents
    @document = Document.new
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end
  end

  def create
    if @document.save
      EventService.new(current_user.id, @document).save
      redirect_to class_room_documents_path(@class_room),
        notice: flash_message("created")
    else
      load_documents
      render :index
    end
  end

  def destroy
    @document.destroy
    redirect_to class_room_documents_path(@class_room),
      notice: flash_message("deleted")
  end

  private
  def document_params
    params.require(:document).permit :title, :attachment, :user_id, :class_room_id
  end

  def find_class_room
    @class_room = ClassRoom.includes(:documents, user_classes: :user).find params[:class_room_id]
  end

  def load_documents
    @documents = @class_room.documents
  end
end
