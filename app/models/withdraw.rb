class Withdraw < ApplicationRecord
  include Reference

  enum status: %w[requested approved rejected]

  validates :status, :withdraw_by_id, presence: true
  validates :amount, presence: { message: "Withdraw amount can't be blank" }

  validates :amount,
            numericality: { greater_than: 0,
                            less_than_or_equal_to: ->(withdraw) { withdraw.withdraw_by.wallet_balance },
                            on: :create }
  validates :payee, presence: { message: "Payee name can't be blank" }
  validates :address, presence: { message: "Address can't be blank" }

  has_many :ledger_entries, as: :entry
  belongs_to :withdraw_by, class_name: 'User'

  before_create { self.ref = generate_ref_code(self.class) }
  after_create :deduct_wallet_balance

  def add_ledger
    entry = if requested?
      ledger_entries.build(user_id: withdraw_by_id,
                           debit: amount,
                           balance: withdraw_by.wallet_balance)
    elsif rejected?
      ledger_entries.build(user_id: withdraw_by_id,
                           credit: amount,
                           balance: withdraw_by.wallet_balance)
    end
    entry&.save
  end

  private

  def deduct_wallet_balance
    withdraw_by.update_attributes(wallet_balance: withdraw_by.wallet_balance - amount)
  end
end
