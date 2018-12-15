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


# respond_to do |format|
#   if @registration.save
#     if @registration.event_stage.present?
#       @registration.event_stage.increment!(:registrations_count)
#     end
#     @registration.create_charge(params) unless @event.is_free?
#     ConfirmationMailer.event_solo_registration(@registration.id).deliver
#     format.html do
#       flash[:danger] = 'Your Registration has been created!'
#       redirect_to event_registration_path(
#         @event,
#         @registration,
#         email_check: @registration.email
#       )
#     end
#   else
#     format.html do
#       flash[:notice] = "There were errors in your submission." +
#         "Your card has NOT been charged."
#       render :new
#     end
#   end
# end
