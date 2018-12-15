class RegistrationDecorator < Draper::Decorator
  delegate_all

  def contact_phone
    if event_team.present?
      event_team.contact_phone
    else
      phone
    end
  end

  def stage_name
    event_stage.try :name
  end

  def team_name
    event_team.try :name
  end

  def stripe_charge_id_text
    if event_team.present?
      event_team.stripe_charge_id
    else
      stripe_charge_id
    end
  end
end
