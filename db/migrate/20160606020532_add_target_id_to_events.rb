class AddTargetIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :target_id, :integer
  end
end
