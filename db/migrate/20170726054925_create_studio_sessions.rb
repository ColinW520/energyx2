class CreateStudioSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :studio_sessions do |t|
      t.integer :display_order
      t.references :coach, foreign_key: true
      t.references :studio_session_type, foreign_key: true
      t.string :day_of_week
      t.string :start_time
      t.string :length
      t.string :link

      t.timestamps
    end
  end
end
