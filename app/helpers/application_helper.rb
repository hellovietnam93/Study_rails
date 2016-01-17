module ApplicationHelper
  def full_title page_title = ""
    base_title = t "static_page.app_name"
    page_title.empty? ? base_title : page_title << " | " << base_title
  end

  def flash_class level
    case level
    when :notice then "alert-info"
    when :error then "alert-error"
    when :alert then "alert-warning"
    when :success then "alert-success"
    end
  end

  def flash_message flash_type, *params
    if params.empty?
      t "flashs.messages.#{flash_type}", model_name: controller_name.classify.normalize
    else
      t "flashs.messages.#{flash_type}", models_name: params[0].join(", ") unless params[0].empty?
    end
  end

  def allowed_file model
    Settings.imports.data_types[0].model == model ? ".csv" : ".csv, .json"
  end

  def i18n_enum model_name, enum
    enum = enum.to_s.pluralize
    model_name = model_name.to_s
    model_name.classify.constantize.public_send(enum).keys.map do |key|
      OpenStruct.new key: key, value: I18n.t("#{model_name.pluralize}.#{enum}.#{key}")
    end.flatten
  end
end
