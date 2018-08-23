class Registration < ApplicationRecord
  belongs_to :event
  belongs_to :event_stage
  belongs_to :event_team

  def retrieve_stripe_charge
    Stripe::Charge.retrieve(self.stripe_charge_id)
  end

  def create_charge(params)
    raise 'Charge has already been created for this registration.' if self.is_paid?

    params = params.with_indifferent_access

    customer = Stripe::Customer.create(
      :email => self.email,
      :source  => params[:stripe_token]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => self.event.price_in_cents,
      :description => "ENERGYX #{self.event.name}",
      :currency    => 'usd'
    )

    self.stripe_customer_id = customer.id
    self.stripe_charge_id = charge.id
    self.is_paid = true if customer && charge
    self.save!
  end

  def self.to_csv
    header = ['Event Name', 'First Name', 'Last Name', 'Phone', 'Shirt Size']
    attributes = []

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |t|
        csv << attributes.map do |attr|
          attr == 'tags' ? t.tags.pluck(:name).split(',').join('|') : t.send(attr)
        end
      end
    end
  end

  private
end
