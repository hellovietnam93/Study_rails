class CreateTimetableDetails < ActiveRecord::Migration
  def change
    create_table :timetable_details do |t|
      t.references :timetable, index: true, foreign_key: true
      t.references :syllabus_detail, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
