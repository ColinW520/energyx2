class AddIsTeamRegistrationToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :is_team_registration, :boolean
  end
end
