class AddTwilioSidToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :twilio_sid, :string
  end
end
