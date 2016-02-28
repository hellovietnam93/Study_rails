class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.references :class_room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
