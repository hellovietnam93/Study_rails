class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :uid
      t.text :description
      t.float :theory_duration
      t.float :exercise_duration
      t.float :practice_duration
      t.float :weight
      t.float :base_hours
      t.text :evaluation

      t.timestamps null: false
    end
  end
end
