class LikesController < ApplicationController
  authorize_resource

  def create
    user = User.find_by_id params[:user_id]
    find_target params[:type], params[:target_id]

    respond_to do |format|
      @like = user.likes.create likeable_type: @target.class, likeable_id: @target.id
      get_total
      format.js
    end
  end

  def destroy
    @like = Like.find params[:id]
    find_target @like.likeable_type, @like.likeable_id

    respond_to do |format|
      @like.destroy
      get_total
      format.js
    end
  end

  private
  def find_target table_name, id
    @target = table_name.constantize.find_by_id id
  end

  def get_total
    @count = @target.likes.count
  end
end
