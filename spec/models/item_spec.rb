require 'rails_helper'

RSpec.describe Item, type: :model do

  describe '#amount' do
    let(:item) { FactoryGirl.build :item, unit_amount: 5, quantity: 2, period_unit: :month, period_count: 2, sales_tax: true }

    it "should return the total value of the item" do
      expect(item.amount).to eql(10.00)
    end

    it "should optionally include sales tax" do
      expect(item.amount(include_tax: true)).to eql(10.85)
    end
  end

  describe '#prorated_amount' do
    it "should return the amortized value" do
      item = FactoryGirl.build(:item, unit_amount: 7, quantity: 1, period_unit: :day, period_count: 3)
      expect(item.prorated_amount(interval: :daily)).to be_within(0.01).of(2.33)
      expect(item.prorated_amount(interval: :weekly)).to be_within(0.01).of(16.33)
      expect(item.prorated_amount(interval: :biweekly)).to be_within(0.01).of(32.67)
      expect(item.prorated_amount(interval: :monthly)).to be_within(0.01).of(72.33)
      expect(item.prorated_amount(interval: :quarterly)).to be_within(0.01).of(214.67)
      expect(item.prorated_amount(interval: :annually)).to be_within(0.01).of(854)

      item = FactoryGirl.build(:item, unit_amount: 14, quantity: 1, period_unit: :week, period_count: 1)
      expect(item.prorated_amount(interval: :daily)).to be_within(0.01).of(2.00)
      expect(item.prorated_amount(interval: :weekly)).to be_within(0.01).of(14.00)
      expect(item.prorated_amount(interval: :biweekly)).to be_within(0.01).of(28.00)
      expect(item.prorated_amount(interval: :monthly)).to be_within(0.01).of(62.00)
      expect(item.prorated_amount(interval: :quarterly)).to be_within(0.01).of(184.00)
      expect(item.prorated_amount(interval: :annually)).to be_within(0.01).of(728.00)

      item = FactoryGirl.build(:item, unit_amount: 5, quantity: 2, period_unit: :month, period_count: 2)
      expect(item.prorated_amount(interval: :daily)).to be_within(0.01).of(0.16)
      expect(item.prorated_amount(interval: :weekly)).to be_within(0.01).of(1.15)
      expect(item.prorated_amount(interval: :biweekly)).to be_within(0.01).of(2.30)
      expect(item.prorated_amount(interval: :monthly)).to eql(5.00)
      expect(item.prorated_amount(interval: :quarterly)).to eql(15.00)
      expect(item.prorated_amount(interval: :annually)).to eql(60.00)

      item = FactoryGirl.build(:item, unit_amount: 199, quantity: 1, period_unit: :year, period_count: 2)
      expect(item.prorated_amount(interval: :daily)).to be_within(0.01).of(0.27)
      expect(item.prorated_amount(interval: :weekly)).to be_within(0.01).of(1.91)
      expect(item.prorated_amount(interval: :biweekly)).to be_within(0.01).of(3.83)
      expect(item.prorated_amount(interval: :monthly)).to be_within(0.01).of(8.29)
      expect(item.prorated_amount(interval: :quarterly)).to be_within(0.01).of(24.88)
      expect(item.prorated_amount(interval: :annually)).to be_within(0.01).of(99.50)
    end

    it "should optionally include sales tax" do
      item = FactoryGirl.build(:item, unit_amount: 5, quantity: 2, period_unit: :month, period_count: 2, sales_tax: true)
      expect(item.prorated_amount(interval: :annually, include_tax: true)).to be_within(0.01).of(65.10)
    end
  end
end
