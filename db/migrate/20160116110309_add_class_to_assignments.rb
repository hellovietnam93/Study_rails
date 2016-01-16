class AddClassToAssignments < ActiveRecord::Migration
  def change
    add_reference :assignments, :class_room, index: true, foreign_key: true
  end
end
