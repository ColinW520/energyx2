class CreateRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :registrations do |t|
      t.references :event, foreign_key: true
      t.string :name
      t.boolean :is_paid
      t.string :subtype
      t.string :phone
      t.string :email
      t.string :stripe_customer_id
      t.string :stripe_charge_id

      t.timestamps
    end
  end
end
