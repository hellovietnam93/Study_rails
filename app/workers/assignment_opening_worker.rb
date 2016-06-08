class AssignmentOpeningWorker < Struct.new :assignment
  include Sidekiq::Worker
  def perform
    assignment.update_attributes status: :opening
  end
end
