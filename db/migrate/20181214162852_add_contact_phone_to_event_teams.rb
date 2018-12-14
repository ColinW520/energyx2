class AddContactPhoneToEventTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :event_teams, :contact_phone, :string
  end
end
