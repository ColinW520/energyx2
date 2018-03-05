class AddCapSizeToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :cap_size, :integer, default: 50
  end
end
