class AddShortDescriptionToCoaches < ActiveRecord::Migration[5.0]
  def change
    add_column :coaches, :short_description, :string
  end
end
