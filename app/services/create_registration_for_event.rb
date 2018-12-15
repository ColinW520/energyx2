class CreateRegistrationForEvent < BaseService
  attr_reader :event, :registration, :token

  def initialize(event:, registration:, token:)
    @event = event
    @registration = registration
    @token = token
  end

  def perform
    if registration.valid?
      create_registration
    else
      ServiceResponse.new(
        success: false,
        object: registration,
        message: "Registration is invalid. Please review the details submitted."
      )
    end
  end

  private

  def create_registration
    if event.is_free?
      create_free_registration
    else
      create_paid_registration
    end
  end

  def create_free_registration
    if registration.save
      increment_stage

      ServiceResponse.new(
        success: true,
        object: registration,
        message: "Successfully registered #{registration.name} for #{event.name} event."
      )
    else
      ServiceResponse.new(
        success: false,
        object: registration,
        message: "Could not create this Registration. Please review the errors below."
      )
    end
  end

  def create_paid_registration
    charge_result = create_charge_for_registration

    if charge_result.success?
      save_with_charge_details!(charge_result.object)

      ServiceResponse.new(
        success: true,
        object: registration.reload,
        message: "Successfully created registration #{registration.name} " +
          "for the #{event.name} event. " + charge_result.message
      )
    else
      charge_result
    end
  end

  def create_charge_for_registration
    CreateChargeForRegistration.new(registration: registration, token: token).perform
  end

  def increment_stage
    if registration.event_stage.present?
      registration.event_stage.increment!(:registrations_count)
    end
  end

  def save_with_charge_details!(charge)
    registration.stripe_charge_id = charge.id
    registration.stripe_customer_id = charge.customer
    registration.is_paid = true
    registration.save!
  end
end
