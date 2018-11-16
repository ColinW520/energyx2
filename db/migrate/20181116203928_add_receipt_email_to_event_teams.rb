class AddReceiptEmailToEventTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :event_teams, :receipt_email, :string
  end
end
