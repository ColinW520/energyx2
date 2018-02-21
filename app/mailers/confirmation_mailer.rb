class ConfirmationMailer < ApplicationMailer
  default template_path: "mailers/confirmations"

  def event_registration(registration_id)
    @registration = Registration.find registration_id
    @event = @registration.event

    mail to: @registration.contact_email, from: 'contact@energyxfitness.com', subject: "Your Registration Confirmation for #{@registration.event.name}"
  end
end
