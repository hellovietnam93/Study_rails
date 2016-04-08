class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :event_type
      t.references :class_room, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :events, :event_type
  end
end
