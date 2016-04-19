class ClassRoomService
  attr_accessor :class_room, :class_room_params

  def initialize class_room, class_room_params = nil
    @class_room = class_room
    @class_room_params = class_room_params
    @semester = @class_room.semester
    @class_rooms = @semester.class_rooms
  end

  def save
    @class_room.enroll_key = generate_enroll_key @class_room
    @class_room.student_key = generate_student_key @class_room

    if @class_room.save
      assign_to_teacher
      return true
    end

    false
  end

  private
  def generate_enroll_key class_room
    enroll_key = class_room.enroll_key
    begin
      enroll_key = SecureRandom.base64
    end until !@class_rooms.pluck(:enroll_key).include?(enroll_key)
    enroll_key
  end

  def generate_student_key class_room
    student_key = class_room.student_key
    begin
      student_key = SecureRandom.base64
    end until(!@class_rooms.pluck(:student_key).include?(student_key) && class_room.enroll_key != student_key)
    student_key
  end

  def assign_to_teacher
    user = User.find_by_email @class_room_params
    if user
      user.user_classes.create class_room: @class_room, status: 0, owner: true
    else
      user = User.create username: @class_room_params, email: @class_room_params,
        password: "12345678", password_confirmation: "12345678", role: 1
    end
    send_mail_to_teacher user
  end

  def send_mail_to_teacher user
    UserMailer.assign_class(user, @class_room).deliver
  end
end
