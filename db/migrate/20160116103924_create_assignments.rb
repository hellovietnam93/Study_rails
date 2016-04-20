class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.integer :type
      t.datetime :start_time
      t.datetime :end_time
      t.string :content

      t.timestamps null: false
    end
  end
end
