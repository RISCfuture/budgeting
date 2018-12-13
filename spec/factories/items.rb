FactoryBot.define do
  factory :item, class: Item do
    categories = %w[Home Gadgets Hobbies Family Food Self-Care Medical
                    Transportation Pets Income Withholdings].freeze

    category { categories.sample }
    sequence(:name) { |i| "Item #{i}" }

    unit_amount { rand(1..1000) }
    quantity { rand(1..10) }

    period_unit { Item.period_units.keys.sample }
    period_count { rand(1..4) }

    income { false }
    budget { FFaker::Boolean.maybe }
    sales_tax { FFaker::Boolean.maybe }

    trait :income do
      income { true }
      budget { false }
      sales_tax { false }
    end
  end
end
