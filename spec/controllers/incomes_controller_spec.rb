require 'rails_helper'

RSpec.describe IncomesController, type: :controller do
  render_views

  describe '#index' do
    before :each do
      @incomes = FactoryBot.create_list(:item, 5, :income)
      FactoryBot.create :item # red herring - not an income
    end

    it "should render a list of incomes" do
      get :index, params: {format: 'json'}
      expect(response.status).to be(200)
      json = JSON.parse(response.body)
      expect(json.map { |i| i['name'] }).
          to match_array(@incomes.map(&:name))
    end
  end

  describe '#create' do
    let(:income_params) { FactoryBot.attributes_for :item }

    it "should create an income" do
      post :create, params: {item: income_params, format: 'json'}
      expect(response.status).to be(201)
      expect(Item.count).to be(1)
      expect(Item.first).to be_income
      expect(Item.first.quantity).to eql(income_params[:quantity])
      expect(JSON.parse(response.body)['name']).to eql(income_params[:name])
    end

    it "should handle validation errors" do
      post :create, params: {item: income_params.merge(name: ' '), format: 'json'}
      expect(response.status).to be(422)
      expect(response.body).to eql('{"errors":{"name":[{"error":"blank"}]}}')
    end
  end

  describe '#update' do
    let(:income) { FactoryBot.create :item, :income }
    let(:income_params) { FactoryBot.attributes_for :item }

    it "should find an income by ID" do
      patch :update, params: {id: 'not-found', item: income_params, format: 'json'}
      expect(response.status).to be(404)

      patch :update, params: {id: FactoryBot.create(:item).to_param, item: income_params, format: 'json'}
      expect(response.status).to be(404)
    end

    it "should update an income" do
      patch :update, params: {id: income.to_param, item: income_params, format: 'json'}
      expect(response.status).to be(200)
      expect(income.reload).to be_income
      expect(income.quantity).to eql(income_params[:quantity])
      expect(JSON.parse(response.body)['name']).to eql(income.name)
    end

    it "should handle validation errors" do
      patch :update, params: {id: income.to_param, item: income_params.merge(name: ' '), format: 'json'}
      expect(response.status).to be(422)
      expect(response.body).to eql('{"errors":{"name":[{"error":"blank"}]}}')
    end
  end

  describe '#destroy' do
    let(:income) { FactoryBot.create :item, :income }

    it "should find an income by ID" do
      delete :destroy, params: {id: 'not-found', format: 'json'}
      expect(response.status).to be(404)

      delete :destroy, params: {id: FactoryBot.create(:item).to_param, format: 'json'}
      expect(response.status).to be(404)
    end

    it "should delete an income" do
      delete :destroy, params: {id: income.to_param, format: 'json'}
      expect(response.status).to be(204)
      expect { income.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
