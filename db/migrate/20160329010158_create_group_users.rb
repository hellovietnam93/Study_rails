class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.integer :status

      t.timestamps null: false
    end

    add_index :group_users, [:group_id, :user_id], unique: true
  end
end
