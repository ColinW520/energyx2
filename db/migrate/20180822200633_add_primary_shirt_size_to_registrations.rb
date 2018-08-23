class AddPrimaryShirtSizeToRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :registrations, :primary_shirt_size, :string
  end
end
