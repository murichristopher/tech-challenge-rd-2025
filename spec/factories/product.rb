FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price { 10.0 }

    trait :free do
      price { 0 }
    end

    trait :expensive do
      price { 1000.0 }
    end
  end
end