class AddFirstNameToCoaches < ActiveRecord::Migration[5.0]
  def change
    add_column :coaches, :first_name, :string
  end
end
