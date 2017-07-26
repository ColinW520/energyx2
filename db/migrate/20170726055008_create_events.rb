class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :organization, foreign_key: true
      t.string :name
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :description
      t.string :link

      t.timestamps
    end
  end
end
