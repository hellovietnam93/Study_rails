class TagsController < ApplicationController
  load_and_authorize_resource :forum

  def index
    @class_room = @forum.class_room
    @posts = @forum.posts.tagged_with params[:tag]
    @post = @forum.posts.build
    @comment = current_user.comments.build
  end
end
