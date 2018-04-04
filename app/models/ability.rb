class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user.senior? || user.junior?

    if user.au?
      can :index, TradeLine, TradeLine.where('slots > ? AND is_active = ?', 0, true).where('statement_date <= :today or (statement_date > :today AND expiration_date > :expiration_date)', today: Time.zone.today.day, expiration_date: Time.zone.today + 30.days ) do |_trade_line|
        true
      end
      can :index, LedgerEntry, LedgerEntry.where(user_id: user.id) do |_ledger_entry|
        true
      end
    end
  end
end
