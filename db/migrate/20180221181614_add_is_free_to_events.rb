class AddIsFreeToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :is_free, :boolean, default: true
  end
end
