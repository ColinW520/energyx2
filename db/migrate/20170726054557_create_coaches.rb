class CreateCoaches < ActiveRecord::Migration[5.0]
  def change
    create_table :coaches do |t|
      t.string :name
      t.string :bio
      t.integer :display_order
      t.string :instagram_link
      t.string :facebook_link
      t.string :twitter_link
      t.string :email

      t.timestamps
    end
  end
end
