include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :ledger_entry do
    credit ""
    debit "9.99"
    balance "9.99"
    association :user
  end
  factory :setting do
    ssn_charge 1
  end

  factory :withdraw do
    amount 9.99
    status 0

    association :withdraw_by, factory: :user, traits: [:au]
  end

  factory :refund do
    reason "MyString"
    cm_service "MyString"
    cm_login "MyString"
    cm_password '123456'
    confirm_password '123456'
    amount "9.99"
    status 0
    reason_for_rejection "MyString"
    reason_for_inprogress "MyString"

    association :purchase
  end

  factory :trade_line do
    is_active true
    slots 10
    bank  'BOA'
    credit_limit 20000
    history Time.zone.yesterday
    statement_date 4
    price 9.99

    association :state
  end

  factory :user do
    sequence(:username) { |i| "username#{i}" } 
    sequence(:email) { |i| "test#{i}@email.com" }
    password "123456"
    status "accepted"

    trait :au do
      role 0
    end

    trait :junior do
      role 1
    end

    trait :senior do
      role 2
    end

    factory :a_user, traits: [:au]
    factory :junior_staff, traits: [:junior]
  end

  factory :state do
    sequence(:name) { |i| "San Fransico#{i}" }
    sequence(:short_code) { |i| "SF#{i}" }
  end

  factory :purchase do
    status 'approved'
    association :user
    association :trade_line
    association :purchased_by, factory: :user

    amount 9.99
  end

  factory :banking_information do
    sequence(:account_number) { |i| "123456789#{i}" }
    routing_info "1234567"
    bank_name "BOA"
    account_name "12345"
  end

  factory :deposit do 
    association :user, traits: [:au]
    association :banking_information

    amount 100
    date_of_deposit Time.zone.now
    attachment { fixture_file_upload("#{Rails.root}/public/apple-touch-icon.png") } 

    before(:create) do |d|
      d.authorization_code = d.generate_ref_code(d.class)
    end
  end

end
