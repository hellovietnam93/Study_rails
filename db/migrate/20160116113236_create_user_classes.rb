class CreateUserClasses < ActiveRecord::Migration
  def change
    create_table :user_classes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :class_room, index: true, foreign_key: true
      t.integer :status
      t.boolean :owner, default: false

      t.timestamps null: false
    end
  end
end
