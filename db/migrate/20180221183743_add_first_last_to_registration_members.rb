class AddFirstLastToRegistrationMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :registration_members, :first_name, :string
    add_column :registration_members, :last_name, :string
  end
end
