class CreateClassRooms < ActiveRecord::Migration
  def change
    create_table :class_rooms do |t|
      t.string :name
      t.string :uid
      t.text :description
      t.references :course, index: true, foreign_key: true
      t.references :semester, index: true, foreign_key: true
      t.string :enroll_key
      t.string :student_key
      t.integer :class_type
      t.integer :registered_student
      t.integer :max_student
      t.datetime :start_date
      t.datetime :end_date
      t.integer :status

      t.timestamps null: false
    end
  end
end
