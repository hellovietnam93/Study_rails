class CreateGroupClasses < ActiveRecord::Migration
  def change
    create_table :group_classes do |t|
      t.string :name
      t.references :class_room, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :slug

      t.timestamps null: false
    end
    add_index :group_classes, :slug, unique: true
  end
end
