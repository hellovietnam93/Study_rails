class ForumsController < ApplicationController
  load_and_authorize_resource

  def show
    @class_room = @forum.class_room
    @posts = @forum.posts
    @post = @forum.posts.build
  end
end
