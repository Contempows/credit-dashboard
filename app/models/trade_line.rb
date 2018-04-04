class TradeLine < ApplicationRecord
  validates :slots, :bank, :credit_limit, :history, :statement_date, :state_id, :price, presence: true
  validates :slots, :credit_limit, numericality: { greater_than: -1 }

  belongs_to :state
  has_many :purchases, dependent: :destroy

  scope :active, -> { where(is_active: true) }
end
