class AddIsCancelledToClasses < ActiveRecord::Migration[5.0]
  def change
    add_column :studio_sessions, :is_cancelled, :boolean, default: false
  end
end
