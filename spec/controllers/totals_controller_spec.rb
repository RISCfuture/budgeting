require 'rails_helper'

RSpec.describe TotalsController, type: :controller do
  describe '#index' do
    render_views

    before :each do
      FactoryBot.create :item, :income, unit_amount: 10, quantity: 2, period_count: 1, period_unit: :day
      FactoryBot.create :item, unit_amount: 5, quantity: 2, period_count: 1, period_unit: :week, sales_tax: true
      FactoryBot.create :item, unit_amount: 3, quantity: 1, period_count: 1, period_unit: :month, sales_tax: false
    end

    it 'should render JSON totals data' do
      get :index, params: {format: 'json'}
      expect(response.status).to be(200)
      expect(JSON.parse(response.body)).
          to eql('income'             => '620.0',
                 'gross_expenditures' => '47.28571428571429',
                 'taxes'              => '3.76428571428571465',
                 'net_expenditures'   => '51.05000000000000465',
                 'total'              => '568.94999999999999535')
    end
  end
end
