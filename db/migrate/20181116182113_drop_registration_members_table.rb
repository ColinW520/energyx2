class DropRegistrationMembersTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :registration_members
  end
end
