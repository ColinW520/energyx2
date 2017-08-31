class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.references :participant, foreign_key: true
      t.string :from_number
      t.string :message_body
      t.integer :parsed_meters
      t.string :parsed_name
      t.boolean :is_valid, default: true
      t.boolean :is_rejected, default: false

      t.timestamps
    end
  end
end
