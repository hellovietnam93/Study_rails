class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :uid
      t.text :description
      t.decimal :theory_duration
      t.decimal :exercise_duration
      t.decimal :practice_duration
      t.decimal :weight
      t.text :evaluation

      t.timestamps null: false
    end
  end
end
