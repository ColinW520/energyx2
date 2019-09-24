class CreateStudios < ActiveRecord::Migration[5.0]
  def change
    create_table :studios do |t|
      t.string :name
      t.text :description
      t.text :address
      t.text :map_embed_code
      t.text :schedule_embed_code

      t.timestamps
    end
  end
end
