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
      OpenStruct.new key: key, value: t("#{model_name.pluralize}.#{enum}.#{key}")
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
    user_classes.find do |user_class|
      user_class.status == "take_in" && user_class.user_id == user.id && user_class.owner
    end
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

  def find_notifies user
    EventUser.includes(event: :class_room).where user_id: user.id, status: "unseen"
  end

  def display_notification notification
    result = case notification.event.event_type
    when "timetable"
      "<i class='fa fa-calendar'></i>".html_safe +
        t("notifications.views.timetable", class_room: notification.event.class_room.name)
    when "new_assignment"
      "<i class='fa fa-tasks'></i>".html_safe +
        t("notifications.views.new_assignment", class_room: notification.event.class_room.name)
    when "edit_assignment"
      "<i class='fa fa-tasks'></i>".html_safe +
        t("notifications.views.edit_assignment", class_room: notification.event.class_room.name)
    when "document"
      "<i class='fa fa-book'></i>".html_safe +
        t("notifications.views.document", class_room: notification.event.class_room.name)
    when "new_assignment_submit"
      "<i class='fa fa-tasks'></i>".html_safe +
        t("notifications.views.new_assignment_submit", class_room: notification.event.class_room.name)
    when "edit_assignment_submit"
      "<i class='fa fa-tasks'></i>".html_safe +
        t("notifications.views.edit_assignment_submit", class_room: notification.event.class_room.name)
    when "new_class_assign"
      "<i class='fa fa-book'></i>".html_safe +
        t("notifications.views.new_class_assign", class_room: notification.event.class_room.name)
    when "new_team"
      "<i class='fa fa-users'></i>".html_safe +
        t("notifications.views.new_team", class_room: notification.event.class_room.name)
    when "new_post"
      "<i class='fa fa-comments'></i>".html_safe +
        t("notifications.views.new_post", class_room: notification.event.class_room.name)
    when "new_comment_post"
      "<i class='fa fa-comments'></i>".html_safe +
        t("notifications.views.new_comment_post")
    when "new_comment_comment"
      "<i class='fa fa-comments'></i>".html_safe +
        t("notifications.views.new_comment_comment")
    end

    link_to result, event_user_path(notification), method: :put
  end

  def link_to_add_fields name, f, association
    new_object = f.object.model.send(association).klass.new
    id = new_object.object_id

    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render association.to_s.singularize + "_fields", f: builder
    end

    link_to name, "#", class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")}
  end

  def display_reminder_type reminder_type
    case reminder_type
    when "start_lesson"
      "fa-book bg-green"
    when "start_submit"
      "fa-star bg-green"
    when "deadline"
      "fa-bell bg-red"
    end
  end

  def display_reminder reminder
    if reminder.start_lesson?
      link_to t("reminders.titles.start_lesson", classroom: reminder.reminderable.uid), reminder.reminderable
    else
      assignment = reminder.reminderable
      link_to t("reminders.titles.#{reminder.remind_type}", assignment: reminder.reminderable.name),
        [assignment.class_room, assignment]
    end
  end

  def load_remindes
    current_user.reminders.where "Date(occur_date) = ? OR Date(occur_date) = ?",
      Date.today, (Date.today + 1.day)
  end
end
