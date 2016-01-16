class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :uid
      t.text :description
      t.decimal :credit
      t.decimal :credit_fee
      t.decimal :theory_duration
      t.decimal :exercise_duration
      t.decimal :practice_duration
      t.decimal :weight
      t.string :en_name
      t.string :abbr_name
      t.string :language
      t.text :evaludation
      t.string :slug

      t.timestamps null: false
    end
    add_index :courses, :slug, unique: true
  end
end
