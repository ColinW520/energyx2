class EventDiscountCode < ApplicationRecord
  belongs_to :event

  def uses
    self.event.registrations.where(discount_code: self.word)
  end

  def usage_count
    uses.count
  end

  def percentage_off
    self.percentage_as_integer.to_f / 100
  end
end
