class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.integer :display_order
      t.string :text
      t.text :answer

      t.timestamps
    end
  end
end
