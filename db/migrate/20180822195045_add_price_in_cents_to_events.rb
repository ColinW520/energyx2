class AddPriceInCentsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :price_in_cents, :integer, default: 100
  end
end
