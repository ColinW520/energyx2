class CreateEventDiscountCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :event_discount_codes do |t|
      t.references :event, foreign_key: true
      t.integer :discount_code, default: 0
      t.string :word
      t.boolean :is_available, default: true
      t.integer :usage_cap, default: 10
      t.integer :times_used, default: 0
      t.integer :percentage_as_integer, default: 10
      t.timestamps
    end
  end
end
