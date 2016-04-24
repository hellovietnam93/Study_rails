class CreateAssignmentSubmits < ActiveRecord::Migration
  def change
    create_table :assignment_submits do |t|
      t.references :user, index: true, foreign_key: true
      t.references :class_room, index: true, foreign_key: true
      t.references :assignment, index: true, foreign_key: true
      t.string :title
      t.text :content
      t.decimal :score

      t.timestamps null: false
    end
  end
end
