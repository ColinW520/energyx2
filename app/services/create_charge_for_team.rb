class CreateChargeForTeam < BaseService
  attr_reader :event, :team, :token

  def initialize(team:, token:)
    @event = team.event
    @team = event_team
    @stripe_token = token
  end

  def perform
    charge = create_charge
    source = charge.source

    ServiceResponse.new(
      success: true,
      object: charge,
      message: "Successfully charged customer's credit card."
    )

  rescue Stripe::CardError => error
    body = error.json_body
    card_error  = body[:error]

    ServiceResponse.new(
      success: false,
      object: team,
      message: "There was an issue with your charge: #{card_error[:message]}"
    )
  end

  private

  def customer
    Stripe::Customer.create(
      email: team.receipt_email,
      source: token
    )
  end

  def create_charge
    Stripe::Charge.create(
      customer: customer.id,
      amount: event.team_price_in_cents,
      description: "ENERGYX #{event.name}",
      currency: 'usd',
      metadata: {
        event: event.id,
        team: team.name
      }
    )
  end
end
