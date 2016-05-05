class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.integer :assignment_type
      t.datetime :start_time
      t.datetime :end_time
      t.text :content
      t.references :class_room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
