class CreateEventTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :event_teams do |t|
      t.references :event, foreign_key: true
      t.string :name
      t.text :allowed_emails
      t.boolean :charge_members
      t.string :created_by

      t.timestamps
    end
  end
end
