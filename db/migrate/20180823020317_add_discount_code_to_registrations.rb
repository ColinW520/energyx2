class AddDiscountCodeToRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :registrations, :discount_code, :string
  end
end
