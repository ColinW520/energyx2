class AddRegistrationSettingsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :registerable, :boolean, default: false
    add_column :events, :registration_ends_at, :datetime
  end
end
