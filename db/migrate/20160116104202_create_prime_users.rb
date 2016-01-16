class CreatePrimeUsers < ActiveRecord::Migration
  def change
    create_table :prime_users do |t|
      t.string :uid
      t.string :name
      t.datetime :birthday
      t.string :program
      t.string :class_name
      t.string :status
      t.string :cohort

      t.timestamps null: false
    end
  end
end
