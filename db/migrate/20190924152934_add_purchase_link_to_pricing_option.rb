class AddPurchaseLinkToPricingOption < ActiveRecord::Migration[5.0]
  def change
    add_column :pricing_options, :purchase_link, :string
  end
end
