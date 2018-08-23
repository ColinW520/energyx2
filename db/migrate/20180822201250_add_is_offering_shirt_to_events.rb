class AddIsOfferingShirtToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :is_offering_shirt, :boolean, default: true
  end
end
