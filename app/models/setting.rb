class Setting < ApplicationRecord
  validates :ssn_charge, presence: { message: 'SSN charge cannot be blank' },
                         numericality: { message: 'SSN charge can only accept numerical values' }
end
