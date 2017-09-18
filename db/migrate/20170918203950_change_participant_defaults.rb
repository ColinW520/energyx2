class ChangeParticipantDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column_default :participants, :is_active, true
  end
end
