
class TestsController < ApplicationController
  load_and_authorize_resource :class_room
  load_and_authorize_resource :online_test

  def index

  end

end
