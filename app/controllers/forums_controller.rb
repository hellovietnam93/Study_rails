class ForumsController < ApplicationController
  authorize_resource
  before_action :find_forum, only: :show

  def show
    @class_room = @forum.class_room
    if @class_room
      redirect_to @class_room unless user_in_class? current_user, @class_room
    end
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end
    @posts = @forum.posts.order updated_at: :desc
    @post = @forum.posts.build
    @comment = current_user.comments.build

    @most_concerned = {}
    @posts.each do |post|
      @most_concerned[post] = post.likes.size + post.comments.size
    end
  end

  private
  def find_forum
    @forum = Forum.includes(posts: [:user, comments: [:user, children: :user]],
      class_room: [user_classes: :user]).find_by_id params[:id]
  end
end
