class EventService
  def initialize user_id, object, action = nil
    @user_id = user_id
    @object = object
    @action = action
  end

  def save
    send "create_event_#{@object.class.table_name}"
  end

  private
  def create_event_timetables
    @event = Event.create user_id: @user_id, event_type: :timetable,
      class_room_id: @object.class_room_id
    @object.class_room.user_classes.take_in.each do |user_class|
      create_event_user user_class.user_id
    end
  end

  def create_event_assignments
    type = @action == "create" ? "new_assignment" : "edit_assignment"

    @event = Event.create user_id: @user_id, event_type: type,
      class_room_id: @object.class_room_id
    @object.class_room.user_classes.take_in.each do |user_class|
      create_event_user user_class.user_id
    end
  end

  def create_event_documents
    @event = Event.create user_id: @user_id, event_type: :document,
      class_room_id: @object.class_room_id
    @object.class_room.user_classes.take_in.each do |user_class|
      create_event_user user_class.user_id
    end
  end

  def create_event_assignment_submits
    type = @action == "create" ? "new_assignment_submit" : "edit_assignment_submit"

    @event = Event.create user_id: @user_id, event_type: type,
      class_room_id: @object.class_room_id

    create_event_for_lecturers
    if @object.share_with_team?
      @object.team.class_teams.each do |class_team|
        create_event_user class_team.user_id
      end
    end
  end

  def create_event_for_lecturers
    @object.class_room.user_classes.where(owner: true).each do |user_class|
      create_event_user user_class.user_id
    end
  end

  def create_event_user user_id
    EventUser.find_or_create_by! user_id: user_id, event: @event
  end
end
