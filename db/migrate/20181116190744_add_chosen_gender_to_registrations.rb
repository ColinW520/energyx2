class AddChosenGenderToRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :registrations, :chosen_gender, :string
  end
end
