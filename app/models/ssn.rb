class Ssn < ApplicationRecord
  enum status: { requested: 0, approved: 1, rejected: 2 }
  validates :ssnorcpn, numericality: true,
                       length: { is: 9, message: 'SSN/CPN should be 9 digits' },
                       uniqueness: { conditions: -> { where.not(status: 'rejected') },
                                     message: 'This SSN/CPN is already in use' }

  has_one :ledger_entry, as: :entry
  belongs_to :user

  after_create :deduct_amount_and_build_ledger

  scope :active, -> { where(status: 'requested') }
  scope :not_active, -> { where.not(status: 'requested') }
  scope :latest_ssns_group_by_users, lambda {
    active
      .includes(:user)
      .order('created_at DESC')
      .group_by(&:user)
  }

  def deduct_amount_and_build_ledger
    user.reload
    user.wallet_balance -= Setting.last.ssn_charge
    user.save
    ledger = build_ledger_entry(user_id: user.id,
                                debit: Setting.last.ssn_charge,
                                balance: user.reload.wallet_balance)
    ledger.save
  end
end
