class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.references :class_room, index: true, foreign_key: true
      t.datetime :date_start
      t.datetime :date_end
      t.datetime :time_start
      t.datetime :time_end
      t.string :title
      t.boolean :repeat, default: false
      t.text :content
      t.boolean :full_day, default: false

      t.timestamps null: false
    end
  end
end
