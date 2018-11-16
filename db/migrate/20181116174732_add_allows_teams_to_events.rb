class AddAllowsTeamsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :allows_teams, :boolean, default: false
  end
end
