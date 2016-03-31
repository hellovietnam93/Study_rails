class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title
      t.string :attachment
      t.references :user, index: true, foreign_key: true
      t.references :class_room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
