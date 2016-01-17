class AddStatusToClassRoom < ActiveRecord::Migration
  def change
    add_column :class_rooms, :status, :integer
  end
end
