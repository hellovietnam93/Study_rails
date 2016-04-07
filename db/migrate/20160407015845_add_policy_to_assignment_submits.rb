class AddPolicyToAssignmentSubmits < ActiveRecord::Migration
  def change
    add_column :assignment_submits, :policy, :integer
  end
end
