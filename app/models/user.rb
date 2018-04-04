class User < ApplicationRecord
  mount_uploader :profile, ImageUploader
  enum role: { au: 0, junior: 1, senior: 2 }
  enum status: { submitted: 0, accepted: 1, rejected: 2 }

  attr_accessor :day, :month, :year

  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, uniqueness: { message: 'This email is already associated with another account',
                                  allow_blank: true },
                    format: { with: Devise.email_regexp, message: 'Please enter a valid Email',
                              allow_blank: true }

  validates :phone, numericality: { message: 'Phone can only accept numerical values' },
                    length: { is: 10 },
                    allow_blank: true
  validates :zipcode, numericality: { message: 'Zipcode can only accept numerical values' },
                      length: { maximum: 6 },
                      allow_blank: true
  validates :day, :month, :year, presence: { if: :other_fields }
  validates :first_name, :last_name, presence: { if: :broker? }

  belongs_to :invited_by, class_name: 'User', optional: true
  has_many :deposits, dependent: :destroy
  has_many :ssns, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :withdraws, dependent: :destroy, foreign_key: 'withdraw_by_id'
  has_many :ledger_entries, dependent: :destroy

  accepts_nested_attributes_for :ssns, reject_if: :reject_blanks, allow_destroy: true

  # Scopes
  scope :applications, -> { where(status: 'submitted') }
  scope :normal_accounts, lambda {
    where(role: 'au', invited_by_id: nil)
      .order(status: :asc, updated_at: :desc)
  }
  scope :broker_accounts_ids, lambda {
    where(role: 'au')
      .order_desc
      .group_by(&:invited_by_id)
      .keys.reject(&:nil?)
  }
  scope :profile_details, lambda {
    where('first_name != :nil and last_name != :nil and address != :nil and social != :nil', nil: '')
  }
  scope :search, lambda { |query|
    where('first_name like ? OR last_name like ? OR email like ?',
          "#{query}%", "#{query}%", "#{query}%").order_desc
  }
  scope :search_email, ->(term) { where('email like ?', "#{term}%") }

  def au?
    role == 'au'
  end

  def staff?
    role == 'junior' || role == 'senior'
  end

  def broker?
    invited_by_id.present? && User.find(invited_by_id).au?
  end

  def other_fields
    day.present? || year.present? || month.present?
  end

  def email_required?
    broker? ? false : super
  end

  def recent_transactions
    query = <<-SQL
      SELECT 'deposit', authorization_code, amount, status, updated_at
      FROM DEPOSITS
      WHERE user_id = #{id}

      UNION

      SELECT 'withdraw', ref, amount, status, updated_at
      FROM WITHDRAWS
      WHERE withdraw_by_id = #{id}


      ORDER BY updated_at DESC
      LIMIT 3
    SQL

    User.execute_query(query)
  end

  def user_orders
    query = <<-SQL
      SELECT 'purchase', ref, amount, status, updated_at
      FROM PURCHASES
      WHERE purchased_by_id = #{id}

      UNION

      SELECT 'refund', ref, amount_refunded, status, updated_at
      FROM REFUNDS
      WHERE purchase_id IN (SELECT id FROM PURCHASES WHERE purchased_by_id = #{id})

      ORDER BY updated_at DESC
      LIMIT 3
    SQL

    User.execute_query(query)
  end

  def increment_sign_in_count
    increment(:sign_in_count)
  end

  def has_active_withdrawl?
    withdraws.where(status: 'Requested').exists?
  end

  def self.orders
    query = <<-SQL
      (SELECT 'refund', ref, amount_refunded, status, updated_at
      FROM REFUNDS
      ORDER BY updated_at DESC
      LIMIT 8)

      UNION

      (SELECT 'purchase', ref, amount, status, updated_at
      FROM PURCHASES
      ORDER BY updated_at DESC
      LIMIT 8)

      ORDER BY updated_at DESC
      LIMIT 8
    SQL

    execute_query(query)
  end

  def self.notifications
    query = <<-SQL
      (SELECT 'deposit', authorization_code, amount, status, updated_at
      FROM DEPOSITS
      ORDER BY updated_at DESC
      LIMIT 3)

      UNION

      (SELECT 'withdraw', ref, amount, status, updated_at
      FROM WITHDRAWS
      ORDER BY updated_at DESC
      LIMIT 3)

      ORDER BY updated_at DESC
      LIMIT 3
    SQL

    execute_query(query)
  end

  def self.execute_query(query)
    ActiveRecord::Base.connection.exec_query(query).rows.map do |trans|
      klass = trans.first.capitalize.constantize
      trans[3] = klass.statuses.invert[trans[3]]
      trans
    end
  end

  def full_name
    [first_name, last_name].join(' ').titleize
  end

  private

  def reject_blanks(attributes)
    if attributes[:id] && attributes[:ssnorcpn].blank?
      ssns.find(attributes[:id]).destroy
      return true
    end
    attributes[:id].blank? && attributes[:ssnorcpn].blank?
  end

  def own_purchases
    Purchase.where(purchased_by: id)
  end
end
