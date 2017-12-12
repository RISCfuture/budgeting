require 'rails_helper'

RSpec.describe ExpendituresController, type: :controller do
  render_views

  describe '#index' do
    before :each do
      @expenditures = FactoryBot.create_list(:item, 5)
      FactoryBot.create :item, :income # red herring - income
    end

    it "should render a list of expenditures" do
      get :index, params: {format: 'json'}
      expect(response.status).to eql(200)
      json = JSON.parse(response.body)
      expect(json.map { |i| i['name'] }).
          to match_array(@expenditures.map(&:name))
    end
  end

  describe '#create' do
    let(:expenditure_params) { FactoryBot.attributes_for :item }

    it "should create an expenditure" do
      post :create, params: {item: expenditure_params, format: 'json'}
      expect(response.status).to eql(201)
      expect(Item.count).to eql(1)
      expect(Item.first).to be_expenditure
      expect(Item.first.quantity).to eql(expenditure_params[:quantity])
      expect(JSON.parse(response.body)['name']).to eql(expenditure_params[:name])
    end

    it "should handle validation errors" do
      post :create, params: {item: expenditure_params.merge(name: ' '), format: 'json'}
      expect(response.status).to eql(422)
      expect(response.body).to eql('{"errors":{"name":[{"error":"blank"}]}}')
    end
  end

  describe '#update' do
    let(:expenditure) { FactoryBot.create :item }
    let(:expenditure_params) { FactoryBot.attributes_for :item }

    it "should find an expenditure by ID" do
      patch :update, params: {id: 'not-found', item: expenditure_params, format: 'json'}
      expect(response.status).to eql(404)

      patch :update, params: {id: FactoryBot.create(:item, :income).to_param, item: expenditure_params, format: 'json'}
      expect(response.status).to eql(404)
    end

    it "should update an expenditure" do
      patch :update, params: {id: expenditure.to_param, item: expenditure_params, format: 'json'}
      expect(response.status).to eql(200)
      expect(expenditure.reload).to be_expenditure
      expect(expenditure.quantity).to eql(expenditure_params[:quantity])
      expect(JSON.parse(response.body)['name']).to eql(expenditure.name)
    end

    it "should handle validation errors" do
      patch :update, params: {id: expenditure.to_param, item: expenditure_params.merge(name: ' '), format: 'json'}
      expect(response.status).to eql(422)
      expect(response.body).to eql('{"errors":{"name":[{"error":"blank"}]}}')
    end
  end

  describe '#destroy' do
    let(:expenditure) { FactoryBot.create :item }

    it "should find an expenditure by ID" do
      delete :destroy, params: {id: 'not-found', format: 'json'}
      expect(response.status).to eql(404)

      delete :destroy, params: {id: FactoryBot.create(:item, :income).to_param, format: 'json'}
      expect(response.status).to eql(404)
    end

    it "should delete an expenditure" do
      delete :destroy, params: {id: expenditure.to_param, format: 'json'}
      expect(response.status).to eql(204)
      expect { expenditure.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
