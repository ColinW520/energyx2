class RegistrationMember < ApplicationRecord
  belongs_to :registration

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
