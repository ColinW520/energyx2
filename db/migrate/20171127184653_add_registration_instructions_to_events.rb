class AddRegistrationInstructionsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :registration_instructions, :text
  end
end
