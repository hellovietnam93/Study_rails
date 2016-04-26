class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.references :class_room, index: true, foreign_key: true
      t.date :date_start
      t.date :date_end
      t.time :time_start
      t.time :time_end
      t.string :title
      t.boolean :repeat, default: false
      t.text :content
      t.boolean :full_day, default: false

      t.timestamps null: false
    end
  end
end
