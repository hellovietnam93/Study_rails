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
      t "flashs.messages.#{flash_type}", model_name: controller_name.classify
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

  def user_in_class? current_user, class_room
    member_class?(current_user, class_room) || manage_class?(current_user, class_room)
  end

  def manage_class? current_user, class_room
    class_room.lecturer.present? && class_room.lecturer.user == current_user && current_user.lecturer?
  end

  def member_class? current_user, class_room
    class_room.students.pluck(:user_id).include?(current_user.id) && current_user.student?
  end

  def present object, klass = nil
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new object, self
    yield presenter if block_given?
    presenter
  end

  def check_lecturer_of_class? user, user_classes
    user.lecturer? && has_lecturer?(user_classes) &&
      is_lecturer_of_class?(user, user_classes)
  end

  def has_lecturer? user_classes
    user_classes.map(&:owner).include? true
  end

  def is_lecturer_of_class? user, user_classes
    user_classes.map(&:user_id).include? user.id
  end

  def is_member_of_class? user, user_classes
    user_classes.find do |user_class|
      user.student? && user_class.status == "take_in" &&
        user_class.user_id == user.id
    end
  end

  def user_avatar user
    if user.avatar.blank?
      image_tag "fallback/default-user-img.png", class: "img-circle profile-user-img img-responsive img-circle"
    else
      image_tag user.avatar, class: "img-circle profile-user-img img-responsive img-circle"
    end
  end
end
