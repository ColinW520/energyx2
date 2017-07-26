class StudioSession < ApplicationRecord
  belongs_to :coach
  belongs_to :studio_session_type
end
