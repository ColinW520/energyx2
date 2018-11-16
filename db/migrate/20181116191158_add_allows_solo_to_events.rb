class AddAllowsSoloToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :allows_solo, :boolean, default: true
  end
end
