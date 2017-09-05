class AddButtonTextToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :button_text, :string
  end
end
