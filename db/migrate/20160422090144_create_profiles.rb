class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.string :school
      t.string :address
      t.string :phone
      t.string :uid
      t.datetime :birthday
      t.string :program
      t.string :class_name
      t.string :cohort
      t.string :status

      t.timestamps null: false
    end
  end
end
