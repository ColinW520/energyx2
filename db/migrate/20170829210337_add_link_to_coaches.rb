class AddLinkToCoaches < ActiveRecord::Migration[5.0]
  def change
    add_column :coaches, :link, :string
  end
end
