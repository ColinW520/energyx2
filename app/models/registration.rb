class Registration < ApplicationRecord
  belongs_to :event
  belongs_to :event_stage
  belongs_to :event_team

  def retrieve_stripe_charge
    Stripe::Charge.retrieve(self.stripe_charge_id)
  end

  def self.to_csv
    header = ['Event Name', 'First Name', 'Last Name', 'Phone', 'Shirt Size']
    attributes = []

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |t|
        csv << attributes.map do |attr|
          t.send(attr)
        end
      end
    end
  end
end
