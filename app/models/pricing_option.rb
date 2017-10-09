class PricingOption < ApplicationRecord
  include RankedModel
  ranks :display_order

  scope :plans, -> { where(subtype: 'plan') }
  scope :passes, -> { where(subtype: 'pass') }
end
