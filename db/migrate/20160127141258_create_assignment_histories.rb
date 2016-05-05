class CreateAssignmentHistories < ActiveRecord::Migration
  def change
    create_table :assignment_histories do |t|
      t.references :user, index: true, foreign_key: true
      t.references :class_room, index: true, foreign_key: true
      t.references :assignment, index: true, foreign_key: true
      t.text :content
      t.references :assignment_submit, index: true, foreign_key: true
      t.integer :editor

      t.timestamps null: false
    end
  end
end
