FactoryBot.define do
  factory :currency do
    currency { Faker::Currency.name }
    value { Faker::Number.decimal(l_digits: 1, r_digits: 5) }
  end
end