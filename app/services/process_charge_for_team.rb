class ProcessChargeForTeam < BaseService
  attr_reader :event, :event_team, :stripe_token

  def initialize(event_team:, stripe_token:)
    @event = event_team.event
    @event_team = event_team
    @stripe_token = stripe_token
  end

  def perform
    if event_team.can_be_charged?
      perform_charge
    else
      ServiceResponse.new(
        success: true,
        object: event_team,
        message: "Team Registration successful!",
      )
    end
  rescue => error
    ServiceResponse.new(
      success: false,
      object: event_team,
      message: error.message,
    )
  end

  def perform_charge
    customer = create_customer
    event_team.stripe_customer_id = customer.id
    event_team.stripe_charge_id = create_charge_for(customer: customer).id
    event_team.save!

    ConfirmationMailer.event_team_registration(event_team.id).deliver if Rails.env.production?

    ServiceResponse.new(
      success: true,
      object: event_team,
      message: "Your team registration is completed and paid. Thank you!",
    )
  rescue Stripe::CardError => error
    body = error.json_body
    card_error  = body[:error]
    ServiceResponse.new(
      success: false,
      object: event_team,
      message: "There was an issue with your card: #{card_error[:message]}",
    )
  end

  private

  def create_customer
    Stripe::Customer.create(
      email: event_team.receipt_email,
      source: stripe_token
    )
  end

  def create_charge_for(customer:)
    Stripe::Charge.create(
      customer: customer.id,
      amount: event_team.event.team_price_in_cents,
      description: "ENERGYX #{event_team.event.name}",
      currency: 'usd'
    )
  end
end
