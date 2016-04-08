class AssignmentSubmitService
  attr_accessor :assignment, :assignment_params

  def initialize assignment, assignment_params = nil
    @assignment = assignment
    @assignment_params = assignment_params
  end

  def save
    @assignment_existed = AssignmentSubmit.find_by class_room_id: @assignment.class_room_id,
      assignment_id: @assignment.assignment_id, user_id: @assignment.user_id
    if @assignment_existed
      @assignment_params = JSON.parse(@assignment.to_json).slice! "id", "created_at", "updated_at"
      @assignment = @assignment.assignment.assignment_submits.first
      update
    else
      @successed = AssignmentSubmit.transaction do
        begin
          @assignment.save
          EventService.new(@assignment.user_id, @assignment, "create").save
          AssignmentHistory.transaction(requires_new: true) do
            @assignment.assignment_histories.create! user_id: @assignment.user_id,
              assignment_id: @assignment.assignment_id, class_room_id: @assignment.class_room_id,
              content: @assignment.content
          end
          true
        rescue
          raise ActiveRecord::Rollback
          false
        end
      end

      unless @successed
        @assignment.errors.add :base, I18n.t("assignment_submits.errors.unknow_errors")
      end

      @successed
    end
  end

  def update current_user = nil
    @successed = AssignmentSubmit.transaction do
      begin
        @assignment.update_attributes @assignment_params
        EventService.new((current_user.nil? ? @assignment.user_id : current_user.id), @assignment, "update").save
        AssignmentHistory.transaction(requires_new: true) do
          create_assignment_history current_user
        end
        true
      rescue
        raise ActiveRecord::Rollback
        false
      end
    end

    unless @successed
      @assignment.errors.add :base, I18n.t("assignment_submits.errors.unknow_errors")
    end

    @successed
  end

  def destroy
    if @assignment.assignment_histories.size == 1
      @assignment.destroy
    else
      @assignment.assignment_histories.order(:created_at).last.destroy
      @assignment.update_attributes content: @assignment.assignment_histories.order(:created_at).last.content
    end
  end

  private
  def create_assignment_history current_user
    assignment_history_params = @assignment_params
    assignment_history_params.delete :policy
    assignment_history_params[:editor] = current_user.id
    @assignment.assignment_histories.create! assignment_history_params
  end
end
