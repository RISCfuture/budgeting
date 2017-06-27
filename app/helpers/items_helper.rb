module ItemsHelper
  def formatted_period(item)
    period = pluralize(item.period_count, item.period_unit.to_s)
    period = if item.period_count == 1
               item.period_unit.to_s
             else
               pluralize(item.period_count, item.period_unit.to_s)
             end
    word = item.quantity == 1 ? "every" : "#{number_with_delimiter item.quantity} per"
    "#{word} #{period}"
  end
end
