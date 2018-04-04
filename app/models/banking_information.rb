class BankingInformation < ApplicationRecord
  validates :account_number, presence: { message: 'Account Number should not be blank' },
                             format: { with: /\A[a-zA-Z0-9]+\z/,
                                       message: 'Account Number format is invalid' },
                             length: { minimum: 9, maximum: 17 }
  validates :routing_info, presence: { message: 'Routing Info should not be blank' },
                           format: { with: /\A[A-Za-z0-9]+\z/,
                                     message: 'Routing Info format is invalid' },
                           length: { minimum: 6, maximum: 9 }
  validates :bank_name, presence: { message: 'Bank Name should not be blank' },
                        length: { maximum: 255 }
  validates :account_name, presence: { message: 'Account Name should not be blank' }

  # TODO: Bank name validation where it checks if the first letter of each word is capital.
  # def validate_bank_name
  #   if bank_name.present?
  #     is_valid_bank_name = (bank_name =~ /\A[A-Za-z ]+\z/).zero?

  #     if !is_valid_bank_name
  #       errors.add(:bank_name, 'is invalid')
  #     else
  #       bank_name.split(' ').each do |string|
  #         next unless string[0] != string[0].upcase
  #         is_valid_bank_name = false
  #         errors.add(:bank_name, 'is invalid') # every word should start with capital letter
  #         break
  #       end
  #     end
  #   end
  # end
end
