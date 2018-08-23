class AddEventStageToRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_reference :registrations, :event_stage, foreign_key: true
  end
end
