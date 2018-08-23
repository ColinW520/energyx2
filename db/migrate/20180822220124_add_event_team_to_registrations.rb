class AddEventTeamToRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_reference :registrations, :event_team, foreign_key: true
  end
end
