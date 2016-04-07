class AddEditorToAssignmentHistories < ActiveRecord::Migration
  def change
    add_column :assignment_histories, :editor, :integer
  end
end
