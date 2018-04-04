class LedgerEntry < ApplicationRecord
  validates :user_id, :entry_id, :entry_type, presence: true

  belongs_to :entry, polymorphic: true
  belongs_to :user
end
