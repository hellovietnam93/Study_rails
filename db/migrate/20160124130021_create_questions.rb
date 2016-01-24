class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :name
      t.references :class_room, index: true, foreign_key: true
      t.integer :question_type
      t.integer :priority
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
