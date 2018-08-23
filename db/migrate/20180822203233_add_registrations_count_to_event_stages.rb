class AddRegistrationsCountToEventStages < ActiveRecord::Migration[5.0]
  def change
    add_column :event_stages, :registrations_count, :integer, default: 0
  end
end
