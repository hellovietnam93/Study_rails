class CreateOnlineTests < ActiveRecord::Migration
  def change
    create_table :online_tests do |t|
      t.references :user, index: true, foreign_key: true
      t.references :class_room, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
