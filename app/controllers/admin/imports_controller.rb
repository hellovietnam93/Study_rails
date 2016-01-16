class Admin::ImportsController < ApplicationController
  before_action :verify_admin
  before_action :init_message, only: :create

  def index
  end

  def create
    if params[:type].present?
      params[:type].each_with_index do |data_type, index|
        import = ImportService.new "#{params[:file][index].tempfile.path.to_s}",
          find_model(data_type).constantize, find_verify_attribute(data_type), data_type
        if import.valid?
          import.save! ? @notice << data_type.gsub("_", " ").capitalize.pluralize :
            @alert << data_type.gsub("_", " ").capitalize.pluralize
        else
          @alert << data_type.gsub("_", " ").capitalize.pluralize
        end
      end
      redirect_to admin_imports_path, notice: flash_message("import.success", @notice),
        alert: flash_message("import.alert", @alert)
    else
      redirect_to admin_imports_path, alert: flash_message("import.no_select_file")
    end
  end

  private
  def find_model data_type
    data_type.split("_").each {|word| word.capitalize!}.join("")
  end

  def init_message
    @notice = Array.new
    @alert = Array.new
  end

  def find_verify_attribute model
    Settings.reload!
    Settings.imports.data_types.detect{|data_type| data_type.model == model}.verify_attributes
  end
end
