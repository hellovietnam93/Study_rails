class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
    add_index :semesters, :slug, unique: true
  end
end
