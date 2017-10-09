class CreatePricingOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :pricing_options do |t|
      t.string :name
      t.string :description
      t.integer :amount_in_cents
      t.string :subtype
      t.integer :display_order

      t.timestamps
    end
  end
end
