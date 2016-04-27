class CreateTimetableRepeats < ActiveRecord::Migration
  def change
    create_table :timetable_repeats do |t|
      t.references :timetable, index: true, foreign_key: true
      t.integer :repeat_type
      t.integer :repeat_on
      t.integer :range
      t.datetime :day_start
      t.datetime :day_end
      t.integer :number_occur
      t.integer :end_type

      t.timestamps null: false
    end
  end
end
