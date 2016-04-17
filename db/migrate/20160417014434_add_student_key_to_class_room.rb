class AddStudentKeyToClassRoom < ActiveRecord::Migration
  def change
    add_column :class_rooms, :student_key, :string
  end
end
