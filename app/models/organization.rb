class Organization < ApplicationRecord
  acts_as_tagger
  extend FriendlyId
  friendly_id :name, use: :slugged

  phony_normalize :phone, default_country_code: 'US'
  validates :phone, phony_plausible: true

  # relationships
  has_many :users
  has_many :contacts
  has_many :messages
  has_many :studio_session_types
  has_many :studio_sessions
  has_many :coaches

  validates :name, presence: true
end
