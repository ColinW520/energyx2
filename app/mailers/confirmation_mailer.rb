class ConfirmationMailer < ApplicationMailer
  default template_path: "mailers/confirmations"

  def event_solo_registration(registration_id)
    @registration = Registration.find registration_id
    @event = @registration.event

    mail(
      to: @registration.email,
      from: 'contact@energyxfitness.com',
      subject: "Your Registration Confirmation for #{@registration.event.name}"
    )
  end

  def event_team_registration(team_id)
    @team = EventTeam.find team_id
    @event = @team.event
    @charge = @team.retrieve_stripe_charge
    @card = @charge.source

    mail(
      to: @team.receipt_email,
      from: 'contact@energyxfitness.com',
      subject: "Your Registration Confirmation for #{@event.name}"
    )
  end
end
