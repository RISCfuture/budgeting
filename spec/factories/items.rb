FactoryGirl.define do
  factory :item, class: Item do
    categories = %w[Home Gadgets Hobbies Family Food Self-Care Medical
                    Transportation Pets Income Withholdings].freeze

    category { categories.sample }
    sequence(:name) { |i| "Item #{i}" }

    unit_amount { rand(1000)+1 }
    quantity { rand(10)+1 }

    period_unit { Item.period_units.keys.sample }
    period_count { rand(4)+1 }

    income false
    budget { FFaker::Boolean.maybe }
    sales_tax { FFaker::Boolean.maybe }

    trait :income do
      income true
      budget false
      sales_tax false
    end
  end
end
