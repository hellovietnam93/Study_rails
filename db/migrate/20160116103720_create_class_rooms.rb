class CreateClassRooms < ActiveRecord::Migration
  def change
    create_table :class_rooms do |t|
      t.string :name
      t.string :uid
      t.text :description
      t.references :course, index: true, foreign_key: true
      t.references :semester, index: true, foreign_key: true
      t.string :enroll_key
      t.integer :class_type
      t.integer :registered_student
      t.integer :max_student
      t.string :slug

      t.timestamps null: false
    end
    add_index :class_rooms, :slug, unique: true
  end
end
