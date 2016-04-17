class Admin::ImportSyllabusesController < ApplicationController

  def create
    if params[:type].present?
      @file_path = params[:file].tempfile.path.to_s
      @course = Course.new

      ReadDocService.new(@file_path, @course).create_course
    else
      redirect_to :back, alert: flash_message("import.no_select_file")
    end
  end
end
