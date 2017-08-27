class User < ApplicationRecord
  default_scope -> { where(deleted_at: nil) }
  phony_normalize :mobile_phone, default_country_code: 'US'
  validates :mobile_phone, phony_plausible: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         invite_key: { email: Devise.email_regexp, first_name: :present?.to_proc, last_name: :present?.to_proc, mobile_phone: :present?.to_proc,}

  def soft_delete!
    update_attribute(:deleted_at, Time.current)
  end

  def inactive_message
    !deleted_at ? super : :deleted_account
  end
end
