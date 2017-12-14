class Registration < ApplicationRecord
  belongs_to :event
  has_many :registration_members, dependent: :destroy
  accepts_nested_attributes_for :registration_members, allow_destroy: true
  alias members registration_members

  validate :require_members


  def create_charge(params)
    raise 'Not Allowed -- Card has already been charged for this registration.' if self.is_paid?

    params = params.with_indifferent_access

    customer = Stripe::Customer.create(
      :email => self.email,
      :source  => params[:stripe_token]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => self.subtype == 'team' ? 10000 : 5000,
      :description => "ENERGYX #{self.event.name} Registration",
      :currency    => 'usd'
    )

    self.stripe_customer_id = customer.id
    self.stripe_charge_id = charge.id
    self.is_paid = true if customer && charge
    self.save!
  end

  private
    def require_members
      errors.add(:base, "You must have at least one person on your registration.") if self.subtype == 'solo' && members.size < 1
      errors.add(:base, "You must have at least two persons on your registration.") if self.subtype == 'team' && members.size < 2
    end
end
