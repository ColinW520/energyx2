class CreateRegistrationMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :registration_members do |t|
      t.references :registration, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone
      t.string :shirt_size

      t.timestamps
    end
  end
end
