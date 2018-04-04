class Deposit < ApplicationRecord
  include Reference

  mount_uploader :attachment, ReceiptUploader

  enum status: { deposited: 0, accepted: 1, rejected: 2 }

  validates :authorization_code, :user_id, :status, presence: true
  validates :amount, presence: { message: "Deposit amount can't be blank" }
  validates :amount, numericality: { other_than: 0 }, allow_blank: false
  validate :deposit_date, if: -> { date_of_deposit.present? }

  has_one :ledger_entry, as: :entry
  belongs_to :user
  belongs_to :banking_information, optional: true

  alias_attribute :ref, :authorization_code

  def generate_auth_code
    self.authorization_code = generate_ref_code(self.class)
  end

  def add_to_wallet
    return unless accepted?
    user.wallet_balance += amount
    user.save
  end

  def add_ledger
    entry = build_ledger_entry(user_id: user_id,
                               credit: amount,
                               balance: user.wallet_balance)
    entry.save
  end

  private

  def deposit_date
    return true if date_of_deposit <= Time.zone.today
    errors.add(:date_of_deposit, 'should be less than or equal to today')
  end
end
