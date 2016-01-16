class AddMiddleAndLastNameToPrimeUser < ActiveRecord::Migration
  def change
    add_column :prime_users, :middle_name, :string
    add_column :prime_users, :last_name, :string
  end
end
