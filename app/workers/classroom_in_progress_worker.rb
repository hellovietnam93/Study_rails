class ClassroomInProgressWorker < Struct.new :class_room
  include Sidekiq::Worker
  def perform
    class_room.update_attributes status: :in_progress if class_room.open?
  end
end
