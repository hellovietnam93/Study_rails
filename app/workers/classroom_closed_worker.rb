class ClassroomClosedWorker < Struct.new :class_room
  include Sidekiq::Worker
  def perform
    class_room.update_attributes status: :closed if class_room.in_progress?
  end
end
