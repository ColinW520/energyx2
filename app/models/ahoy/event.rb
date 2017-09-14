module Ahoy
  class Event < ActiveRecord::Base
    include Ahoy::Properties

    self.table_name = "ahoy_events"

    scope :not_user, -> { where(user_id: nil) }

    belongs_to :visit
    belongs_to :user, optional: true
  end
end
