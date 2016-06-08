class AssignmentClosedWorker < Struct.new :assignment
  include Sidekiq::Worker
  def perform
    assignment.update_attributes status: :closed
  end
end
