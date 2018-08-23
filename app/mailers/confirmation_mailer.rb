class ConfirmationMailer < ApplicationMailer
  default template_path: "mailers/confirmations"

  def event_registration(registration_id)
    @registration = Registration.find registration_id
    @event = @registration.event

    mail(
      to: @registration.email,
      from: 'contact@energyxfitness.com',
      subject: "Your Registration Confirmation for #{@registration.event.name}"
    ) unless Rails.env.development?
  end
end
