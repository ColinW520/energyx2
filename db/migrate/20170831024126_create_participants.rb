class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.string :name
      t.string :mobile_phone
      t.integer :submissions_count
      t.boolean :is_active

      t.timestamps
    end
  end
end
