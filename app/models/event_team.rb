class EventTeam < ApplicationRecord
  belongs_to :event
  has_many :registrations

  has_many :registrations, dependent: :destroy
  accepts_nested_attributes_for :registrations, allow_destroy: true

  validate :min_registrations
  validate :max_registrations
  validates_presence_of :stripe_charge_id, if: lambda { |t| t.event.is_paid? }
  validates_presence_of :stripe_customer_id, if: lambda { |t| t.event.is_paid? }

  def can_be_charged?
    !has_paid? && event.is_paid?
  end

  def has_paid?
    stripe_customer_id.present? && stripe_charge_id.present?
  end

  def retrieve_stripe_charge
    if stripe_charge_id.present?
      Stripe::Charge.retrieve(stripe_charge_id)
    end
  end

  private

  def min_registrations
    if registrations.length < 2
      return errors.add :base, "Teams must have at least two members."
    end
  end

  def max_registrations
    if registrations.length > 4
      return errors.add :base, "Teams can't have more than 4 people."
    end
  end
end
