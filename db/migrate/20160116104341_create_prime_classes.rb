class CreatePrimeClasses < ActiveRecord::Migration
  def change
    create_table :prime_classes do |t|
      t.string :semester
      t.string :student_id
      t.integer :class_id
      t.string :class_type
      t.string :course_id
      t.string :course_title
      t.string :reg_status

      t.timestamps null: false
    end
  end
end
