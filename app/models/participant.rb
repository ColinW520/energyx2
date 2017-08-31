class Participant < ApplicationRecord
  has_many :submissions, dependent: :destroy
end
