class AddRegistrationColumnsToEventTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :event_teams, :stripe_customer_id, :string
    add_column :event_teams, :stripe_charge_id, :string
    add_column :event_teams, :division, :string
  end
end
