class RemoveUnusedColumnsFromEventTeams < ActiveRecord::Migration[5.0]
  def change
    remove_column :event_teams, :allowed_emails
    remove_column :event_teams, :charge_members
    remove_column :event_teams, :created_by
  end
end
