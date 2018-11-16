class AddTeamPriceInCentsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :team_price_in_cents, :integer
  end
end
