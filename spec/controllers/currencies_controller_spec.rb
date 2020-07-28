require 'rails_helper'

RSpec.describe CurrenciesController, type: :controller do
  describe 'index' do
    it 'error if not authenticated' do
      get :index
      res = JSON.parse(response.body)
      expect(res['error']).to eq('Invalid Request')
    end

    it 'returns status 200' do
      request.headers.merge!({ 'Authorization' => user_and_token })
      get :index
      expect(response.status).to eq 200
      expect(response).to have_http_status(:ok)
    end

    it 'wrong token' do
      user_and_token
      request.headers.merge!({ 'Authorization' => 'lfj' })
      get :index
      expect(response.status).to eq 401
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns collection of currencies' do
      2.times do
        FactoryBot.create(:currency)
      end
      request.headers.merge!({ 'Authorization' => user_and_token })
      get :index
      res = JSON.parse(response.body)
      expect(res.size).to eq 2
    end

    it 'error with bad sort request' do
      FactoryBot.create(:currency)
      request.headers.merge!({ 'Authorization' => user_and_token })
      get :index, params: { sort: 'bla' }
      res = JSON.parse(response.body)
      expect(res['error']).to eq 'Bad Request'
      expect(response.status).to eq 400
    end

    it 'error with bad filter request' do
      FactoryBot.create(:currency)
      request.headers.merge!({ 'Authorization' => user_and_token })
      get :index, params: { filter: 'bla' }
      res = JSON.parse(response.body)
      expect(res['error']).to eq 'Bad Request'
      expect(response.status).to eq 400
    end
  end

  describe 'show' do
    it 'error if not authenticated' do
      get :show, params: { id: 1 }
      res = JSON.parse(response.body)
      expect(res['error']).to eq('Invalid Request')
    end

    it 'return json object' do
      currency = FactoryBot.create(:currency)
      request.headers.merge!({ 'Authorization' => user_and_token })
      get :show, params: { id: currency.id }
      expect(response.status).to eq 200
      res = JSON.parse(response.body)
      expect(res['id']).to eq currency.id
    end

    it 'error if not exists' do
      request.headers.merge!({ 'Authorization' => user_and_token })
      get :show, params: { id: 1 }
      expect(response.status).to eq 400
      res = JSON.parse(response.body)
      expect(res['error']).to eq 'Currency with this id does not exists'
    end
  end

  describe 'create' do
    it 'error if not authenticated' do
      post :create, params: { currency: 'CHF' }
      res = JSON.parse(response.body)
      expect(res['error']).to eq('Invalid Request')
    end

    it 'creates new currency' do
      cn = FactoryBot.create(:currency_name)
      request.headers.merge!({ 'Authorization' => user_and_token })
      post :create, params: { currency: cn.shortening }
      expect(response.status).to eq 201
      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['currency']).to eq cn.title
    end

    it 'currency does not exists' do
      request.headers.merge!({ 'Authorization' => user_and_token })
      post :create, params: { currency: 'HHH' }
      expect(response.status).to eq 400
      expect(response).to have_http_status(:bad_request)
      res = JSON.parse(response.body)
      expect(res['error']).to eq 'There is no currency with the name HHH'
    end
  end

  describe 'delete' do
    it 'error if not authenticated' do
      delete :destroy, params: { id: 1 }
      res = JSON.parse(response.body)
      expect(res['error']).to eq('Invalid Request')
    end

    it 'delete currency' do
      currency = FactoryBot.create(:currency)
      request.headers.merge!({ 'Authorization' => user_and_token })
      delete :destroy, params: { id: currency.id }
      expect(response.status).to eq 200
      expect(response).to have_http_status(:ok)
    end
  end
end
