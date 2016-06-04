class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :remind_type
      t.integer :reminderable_id
      t.string :reminderable_type
      t.datetime :occur_date

      t.timestamps null: false
    end
    add_index :reminders, :reminderable_id
  end
end
