class ForumsController < ApplicationController
  load_and_authorize_resource

  def show
    @class_room = @forum.class_room
    if @class_room
      redirect_to @class_room unless user_in_class? current_user, @class_room
    end
    @posts = @forum.posts
    @post = @forum.posts.build
    @comment = current_user.comments.build
  end
end
