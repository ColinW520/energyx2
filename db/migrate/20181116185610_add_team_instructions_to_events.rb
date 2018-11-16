class AddTeamInstructionsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :team_instructions, :string
  end
end
