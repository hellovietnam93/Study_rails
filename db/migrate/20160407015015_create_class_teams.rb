class CreateClassTeams < ActiveRecord::Migration
  def change
    create_table :class_teams do |t|
      t.references :user, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
