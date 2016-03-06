class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :target_id
      t.string :target_type

      t.timestamps null: false
    end

    add_index :likes, :target_type
    add_index :likes, :target_id
  end
end
