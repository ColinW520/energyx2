class CreateChallenges < ActiveRecord::Migration[5.0]
  def change
    create_table :challenges do |t|
      t.string :category
      t.string :name
      t.text :description
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
