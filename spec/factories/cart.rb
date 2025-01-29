FactoryBot.define do
  factory :cart do
    total_price { 0 }

    trait :with_items do
      after(:create) do |cart|
        create(:cart_item, cart: cart)
      end
    end

    trait :with_multiple_items do
      after(:create) do |cart|
        create_list(:cart_item, 3, cart: cart)
      end
    end

    trait :abandoned do
      active { false }
      abandoned_at { 8.days.ago }
    end
  end
end