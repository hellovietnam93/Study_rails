class CreateEventUsers < ActiveRecord::Migration
  def change
    create_table :event_users do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :status, default: 0
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
