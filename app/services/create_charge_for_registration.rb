class CreateChargeForRegistration < BaseService
  attr_reader :event, :registration, :token

  def initialize(registration:, token:)
    @event = registration.event
    @registration = registration
    @token = token
  end

  def perform
    charge = create_charge
    source = charge.source

    ServiceResponse.new(
      success: true,
      object: charge,
      message: "Successfully charged #{source.brand} ending in " +
        "#{source.last4} the event registration fee."
    )

  rescue Stripe::CardError => error
    body = error.json_body
    card_error  = body[:error]

    ServiceResponse.new(
      success: false,
      object: registration,
      message: "There was an issue with your charge: #{card_error[:message]}"
    )
  end

  private

  def customer
    Stripe::Customer.create(
      email: registration.email,
      source: token
    )
  end

  def create_charge
    Stripe::Charge.create(
      customer: customer.id,
      amount: event.price_in_cents,
      description: "ENERGYX #{event.name}",
      currency: "usd",
      metadata: {
        event: event.id,
        registration: registration.name
      }
    )
  end
end
