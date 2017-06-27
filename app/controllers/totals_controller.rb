class TotalsController < ApplicationController
  def index
    items               = Item.all.to_a
    @income             = income(items)
    @gross_expenditures = gross_expenditures(items)
    @net_expenditures   = net_expenditures(items)

    respond_to do |format|
      format.json # index.json.jbuilder
    end
  end

  private

  def income(items)
    items.inject(0) { |sum, item| sum + (item.income? ? item.prorated_amount : 0) }
  end

  def gross_expenditures(items)
    items.inject(0) { |sum, item| sum + (item.expenditure? ? item.prorated_amount : 0) }
  end

  def net_expenditures(items)
    items.inject(0) { |sum, item| sum + (item.expenditure? ? item.prorated_amount(include_tax: true) : 0) }
  end
end
