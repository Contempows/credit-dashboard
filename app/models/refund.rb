class Refund < ApplicationRecord
  include Reference

  mount_uploader :attachment, FileUploader
  attr_accessor :confirm_password, :info

  enum status: { submitted: 0, accepted: 1, partially_accepted: 2, rejected: 3, in_progress: 4 }

  validates :reason, presence: { message: "Reason can't be blank" }
  validates :purchase_id, presence: true
  validates :cm_service, :cm_login, :cm_password,
            :confirm_password, presence: { on: :create, if: :cms_true? }
  # validates :amount, numericality: { greater_than: 0 }, on: :update
  validate :validate_pwd, on: :create
  # validate :validate_refund_amount, on: :update
  validates :amount_refunded,
            numericality: { greater_than: -1,
                            less_than_or_equal_to: ->(refund) { refund.purchase.amount } },
            allow_nil: true
  validates :reason_for_rejection, presence: { message: "Reason for rejection can't be blank" },
                                   if: :rejected?
  validates :reason_for_inprogress, presence: true, if: :in_progress?
  validates :attachment, presence: { if: :attachment_true? }

  has_one :ledger_entry, as: :entry
  belongs_to :purchase

  scope :active, -> { where(status: %w[submitted in_progress]) }

  before_create :encode_cms_data
  before_create { self.ref = generate_ref_code(self.class) }
  before_update :check_amount_refunded

  def add_ledger
    user = purchase.purchased_by
    entry = build_ledger_entry(user_id: user.id,
                               credit: amount_refunded,
                               balance: user.wallet_balance)
    entry.save
  end

  def add_money
    user = purchase.purchased_by
    user.wallet_balance += amount_refunded
    user.save
  end

  private

  def validate_pwd
    errors.add(:cm_password, I18n.t('refund.pwd_match')) if cm_password != confirm_password
  end

  def cms_true?
    (reason == 'Other') && (info == 'I have credit monitoring service')
  end

  def attachment_true?
    (reason == 'Other') && (info == 'I have a credit report')
  end

  def encode_cms_data
    self.cm_login = Base64.encode64(cm_login)
    self.cm_password = Base64.encode64(cm_password)
  end

  def check_amount_refunded
    if status == 'partially_accepted'
      errors.add(:amount_refunded, 'Refunded Amount should be greater than zero') if amount_refunded.zero?
    end
  end

  # def claim_amount
  #   purchase.amount + purchase.total_refunded_amount
  # end

  # def validate_refund_amount
  #   return true unless claim_amount > purchase.amount
  #   errors.add(:amount, I18n.t('refund.claim_amount'))
  # end
end
