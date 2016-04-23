class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.text :content
      t.references :user, index: true, foreign_key: true
      t.integer :postable_id
      t.string :postable_type
      t.references :class_room, index: true, foreign_key: true
      t.boolean :approved, default: false

      t.timestamps null: false
    end
  end
end
