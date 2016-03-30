class CreateTimeTables < ActiveRecord::Migration
  def change
    create_table :time_tables do |t|
      t.references :class_room, index: true, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.string :title
      t.text :content

      t.timestamps null: false
    end
  end
end
