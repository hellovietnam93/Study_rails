class CreateTimetableRepeats < ActiveRecord::Migration
  def change
    create_table :timetable_repeats do |t|
      t.references :timetable, index: true, foreign_key: true
      t.integer :repeat_type
      t.integer :repeat_on
      t.integer :range
      t.date :day_start

      t.timestamps null: false
    end
  end
end
