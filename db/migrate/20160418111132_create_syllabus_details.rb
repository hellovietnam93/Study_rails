class CreateSyllabusDetails < ActiveRecord::Migration
  def change
    create_table :syllabus_details do |t|
      t.references :syllabus, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true
      t.string :title

      t.timestamps null: false
    end
  end
end
