class AddCapSizeToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :cap_size, :integer
  end
end
