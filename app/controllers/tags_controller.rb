class TagsController < ApplicationController
  load_and_authorize_resource :forum

  def show
    @class_room = @forum.class_room
    if @class_room
      redirect_to @class_room unless user_in_class? current_user, @class_room
    end
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end
    @posts = @forum.posts.tagged_with(params[:id]).page params[:page]
    @post = @forum.posts.build
    @comment = current_user.comments.build
    @related_post = @class_room.posts.tagged_with(params[:id]).order updated_at: :desc
  end
end
