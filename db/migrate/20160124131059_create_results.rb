class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :question, index: true, foreign_key: true
      t.references :answer, index: true, foreign_key: true
      t.references :online_test, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
