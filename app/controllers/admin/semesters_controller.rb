class Admin::SemestersController < ApplicationController
  load_and_authorize_resource

  def index
    @semesters = @semesters.order name: :asc
    @semester = Semester.new
  end

  def new

  end

  def create
    respond_to do |format|
      if @semester.save
        list_all_semesters
      end
      format.js
    end
  end

  def show

  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    respond_to do |format|
      if @semester.update_attributes semester_params
        list_all_semesters
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @semester.destroy
        list_all_semesters
      end
      format.js
    end
  end

  private
  def semester_params
    params.require(:semester).permit Semester::ATTRIBUTES_PARAMS
  end

  def list_all_semesters
    @semesters = Semester.all.order name: :asc
  end
end
