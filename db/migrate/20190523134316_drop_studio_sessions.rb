class DropStudioSessions < ActiveRecord::Migration[5.0]
  def change
    drop_table :studio_sessions
  end
end
