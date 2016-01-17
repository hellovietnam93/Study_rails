class ClassRoomService
  attr_accessor :class_room, :class_room_params

  def initialize class_room, class_room_params = nil
    @class_room = class_room
    @class_room_params = class_room_params
    @semester = @class_room.semester
  end

  def save
    @class_room.enroll_key = generate_enroll_key @class_room
    if @class_room.save
      return true
    end

    false
  end

  private
  def generate_enroll_key class_room
    @class_rooms = @semester.class_rooms
    enroll_key = class_room.enroll_key
    begin
      enroll_key = SecureRandom.base64
    end until !@class_rooms.pluck(:enroll_key).include?(enroll_key)
    enroll_key
  end
end
