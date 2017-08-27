class CreateStudioSessionTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :studio_session_types do |t|
      t.string :name
      t.string :description
      t.string :promo_video_url
      t.boolean :active
      t.string :slug
      t.integer :display_order

      t.timestamps
    end
  end
end
