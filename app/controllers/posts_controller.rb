class PostsController < ApplicationController
  load_and_authorize_resource :forum
  load_and_authorize_resource

  def create
    if @post.save
      redirect_to @forum, notice: flash_message("created")
    else
      flash[:alert] = flash_message "not_created"
      render "forums/show"
    end
  end

  def edit
  end

  def update
    if params.has_key? "approved"
      @post.update_attributes approved: params[:approved]
      respond_to do |format|
        format.js
      end
    else
      if @post.update_attributes post_params
        redirect_to @forum, notice: flash_message("updated")
      else
        flash[:alert] = flash_message "not_updated"
        @posts = @forum.posts
        render "forums/show"
      end
    end
  end

  def destroy
    if @post.destroy
       flash[:notice] = flash_message "deleted"
    else
      flash[:alert] = flash_message "not_deleted"
    end

    redirect_to @forum
  end

  private
  def post_params
    params.require(:post).permit Post::ATTRIBUTES_PARAMS
  end
end
