class CreateEventStages < ActiveRecord::Migration[5.0]
  def change
    create_table :event_stages do |t|
      t.references :event, foreign_key: true
      t.string :name
      t.integer :cap_size
      t.datetime :starting_time

      t.timestamps
    end
  end
end
