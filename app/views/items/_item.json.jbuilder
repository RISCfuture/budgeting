json.call item, :id, :category, :name,
          :quantity, :unit_amount,
          :period_unit, :period_count

json.call(item, :budget, :sales_tax) unless item.income?

json.formatted_period formatted_period(item)
json.prorated_amount item.prorated_amount
