class LikesController < ApplicationController
  authorize_resource

  def create
    user = User.find_by_id params[:user_id]
    find_target params[:type], params[:target_id]

    respond_to do |format|
      @like = user.likes.create target_type: @target.class.table_name,
        target_id: @target.id
      get_total
      format.js
    end
  end

  def destroy
    @like = Like.find params[:id]
    find_target @like.target_type, @like.target_id

    respond_to do |format|
      @like.destroy
      get_total
      format.js
    end
  end

  private
  def find_target table_name, id
    @target = table_name.classify.constantize.find_by_id id
  end

  def get_total
    @count = Like.find_by_target(@target.class.table_name, @target.id).count
  end
end
