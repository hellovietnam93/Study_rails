class UsersController < ApplicationController
  load_and_authorize_resource

  def show

  end

  private
  def find_model
    @model = Users.find(params[:id]) if params[:id]
  end
end
