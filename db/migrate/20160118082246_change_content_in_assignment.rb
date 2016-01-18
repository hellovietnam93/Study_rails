class ChangeContentInAssignment < ActiveRecord::Migration
  def change
    change_column :assignments, :content, :text
    rename_column :assignments, :type, :assignment_type
  end
end
