FactoryBot.define do
  factory :cart_item do
    cart
    product
    quantity { 1 }

    trait :multiple_quantity do
      quantity { 3 }
    end
  end
end