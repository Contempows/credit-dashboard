class Purchase < ApplicationRecord
  include Reference

  mount_uploader :file_for_special_add, ReceiptUploader
  mount_uploader :file_for_ssn, ReceiptUploader
  mount_uploader :file_for_dl, ReceiptUploader

  enum status: { initiated: 0, submitted: 1, approved: 2, rejected: 3 }

  validates :reason_for_rejection, presence: { message: 'Reason for rejection cannot be blank' },
                                   if: :rejected?
  # validates :file_for_special_add, presence: { message: 'Please select a file for special address' },
  #                                  if: -> { trade_line.special_add }, on: :create
  validates :file_for_ssn, presence: { message: 'Please select a file for SSN' },
                           if: -> { trade_line.ssn_req }, on: :create
  validates :file_for_dl, presence: { message: 'Please select a file for Driving License' },
                          if: -> { trade_line.dl_req }, on: :create

  has_many :refunds, dependent: :destroy
  has_many :ledger_entries, as: :entry
  belongs_to :user
  belongs_to :purchased_by, class_name: 'User'
  belongs_to :trade_line

  before_create { self.ref = generate_ref_code(self.class) }
  before_update :check_amounts

  scope :search, ->(term) { where(purchased_by: User.search_email(term)) }

  def has_active_refund?
    refunds.where(status: %w[submitted in_progress]).exists?
  end

  def total_refunded_amount
    refunds.where(status: %w[accepted partially_accepted]).sum(:amount_refunded)
  end

  def reduce_trade_line_slots
    tl = trade_line
    tl.slots -= 1 if tl.slots >= 1
    tl.save
  end

  def increase_trade_line_slots
    tl = trade_line
    tl.slots += 1
    tl.save
  end

  def deduct_wallet_balance(amount)
    u = purchased_by
    u.wallet_balance -= amount
    u.save
  end

  def add_wallet_balance
    u = purchased_by
    u.wallet_balance += amount
    u.save
  end

  def add_ledger
    entry = if submitted?
      ledger_entries.build(user_id: purchased_by_id,
                           debit: amount,
                           balance: purchased_by.wallet_balance)
    elsif rejected?
      ledger_entries.build(user_id: purchased_by_id,
                           credit: amount,
                           balance: purchased_by.wallet_balance)
    end
    entry&.save
  end

  private

  def check_amounts
    tl = trade_line
    user = purchased_by

    if user.wallet_balance.zero?
      errors.add(:amount, 'for purchase cant be added. Add money to your wallet to buy a Tradeline')
      throw(:abort)
    end
    if user.wallet_balance < tl.price
      errors.add(:amount,
                 "for purchase cant be added. You dont have enough Wallet Balance $ #{user.wallet_balance}")
      throw(:abort)
    end
  end
end
