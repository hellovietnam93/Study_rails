class PostsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :show
  load_and_authorize_resource :forum, only: :show

  def create
    if @post.save
      EventService.new(current_user.id, @post).save
      redirect_to :back, notice: flash_message("created")
    else
      flash[:alert] = flash_message "not_created"
      render "#{post_params[:postable_type].downcase.pluralize}/show"
    end
  end

  def edit
    if @post.postable_type == "Forum"
      @forum = @post.postable
      @class_room = @forum.class_room
      if @class_room
        redirect_to @class_room unless user_in_class? current_user, @class_room
      end
      @requests = @class_room.user_classes.select do |user_class|
        user_class.status == "waiting"
      end
      @posts = @forum.posts.order(updated_at: :desc).page params[:page]

      @most_concerned = {}
      @posts.each do |post|
        @most_concerned[post] = post.likes.size + post.comments.size
      end
    end
  end

  def update
    if params.has_key? "approved"
      @post.update_attributes approved: params[:approved]
      respond_to do |format|
        format.js
      end
    else
      if @post.update_attributes post_params
        redirect_to :back, notice: flash_message("updated")
      else
        flash[:alert] = flash_message "not_updated"
        @posts = @post.postable.posts
        render "#{@post.postable.class.table_name}/show"
      end
    end
  end

  def destroy
    if @post.destroy
       flash[:notice] = flash_message "deleted"
    else
      flash[:alert] = flash_message "not_deleted"
    end

    redirect_to :back
  end

  def show
    @class_room = @forum.class_room
    if @class_room
      redirect_to @class_room unless user_in_class? current_user, @class_room
    end
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end
    @post = Post.includes(:user, :likes,
      comments: [:user, :likes, children: [:user, :likes]], class_room: :posts).find_by_id params[:id]
    @comment = current_user.comments.build
    @related_post = @class_room.posts.tagged_with(@post.tag_list).order updated_at: :desc
  end

  private
  def post_params
    params.require(:post).permit Post::ATTRIBUTES_PARAMS
  end
end
