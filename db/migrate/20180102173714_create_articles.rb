class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :slug
      t.string :preview_text
      t.text :body
      t.string :author
      t.datetime :available_at

      t.timestamps
    end
  end
end
