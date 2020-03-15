# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    account
    kind { 'credit' }
    description { 'deposit' }
    value { Faker::Commerce.price(range: 10..100.0, as_string: true) }
    balance { Faker::Commerce.price(range: 10..1000.0, as_string: true) }
  end
end
