class CreateTeamForEvent < BaseService
  attr_reader :event, :team, :token

  def initialize(event:, team:, token:)
    @event = event
    @team = team
    @token = token
  end

  def perform
    if team.valid?
      create_team
    else
      ServiceResponse.new(
        success: false,
        object: team,
        message: "Team is invalid. Please review the details you submitted."
      )
    end
  end

  private

  def create_team
    if event.is_free?
      create_free_team
    else
      create_paid_team
    end
  end

  def create_free_team
    if team.save
      ServiceResponse.new(
        success: true,
        object: team,
        message: "Successfully created team #{team.name} for #{event.name} event."
      )
    else
      ServiceResponse.new(
        success: false,
        object: team,
        message: "Could not create this team."
      )
    end
  end

  def create_paid_team
    charge_result = create_charge_for_team

    if charge_result.success?
      save_with_charge_details!(charge_result.object)

      ServiceResponse.new(
        success: true,
        object: team.reload,
        message: "Successfully created team #{team.name} for the #{event.name} event. " +
          charge_result.message
      )
    else
      charge_result
    end
  end

  def create_charge_for_team
    CreateChargeForTeam.new(team: team, token: token).perform
  end

  def save_with_charge_details!(charge)
    team.stripe_charge_id = charge.id
    team.stripe_customer_id = charge.customer
    team.registrations.each do |registration|
      registration.is_paid = true
      registration.stripe_charge_id = team.stripe_charge_id
      registration.stripe_customer_id = team.stripe_customer_id
    end
    team.save!
  end
end
