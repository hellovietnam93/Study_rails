class AddTeamToAssignmentSubmits < ActiveRecord::Migration
  def change
    add_reference :assignment_submits, :team, index: true, foreign_key: true
    add_reference :assignment_histories, :team, index: true, foreign_key: true
    add_column :assignment_histories, :title, :string
  end
end
