class CreateSyllabuses < ActiveRecord::Migration
  def change
    create_table :syllabuses do |t|
      t.references :course, index: true, foreign_key: true
      t.string :title
      t.integer :week

      t.timestamps null: false
    end
  end
end
