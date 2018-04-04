class State < ApplicationRecord
  validates :name, :short_code, presence: true, uniqueness: true
end
