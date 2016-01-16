class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_column :users, :role, :integer
    add_index :users, :slug, unique: true
  end
end
