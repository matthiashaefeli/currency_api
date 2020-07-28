require 'rails_helper'
require './spec/support/authorization_helper'

RSpec.configure do |c|
  c.include AuthorizationHelper
end

RSpec.describe UsersController, type: :controller do
  describe 'create' do
    it 'creates successfully a user, returns status' do
      post :create,
           params: { user: { email: 'test@test.com', password: 'secret' } },
           as: :json
      expect(response.status).to eq 201
      expect(response).to have_http_status(:created)
    end

    it 'creates successfully a user, returns user' do
      post :create,
           params: { user: { email: 'test@test.com', password: 'secret' } },
           as: :json
      res = JSON.parse(response.body)
      expect(res['email']).to eq 'test@test.com'
    end

    it 'return status 422 if user was not created' do
      post :create,
           params: { user: { email: 'test@test.com' } },
           as: :json
      expect(response.status).to eq 422
    end

    it 'return status 422 if user was not created' do
      post :create,
           params: { user: { password: 'secret' } },
           as: :json
      expect(response.status).to eq 422
    end

    it 'return error if user was not created' do
      post :create,
           params: { user: { email: 'test@test.com' } },
           as: :json
      res = JSON.parse(response.body)
      expect(res).to eq({ 'password' => ["can't be blank"] })
    end

    it 'return error if user was not created' do
      post :create,
           params: { user: { password: 'secret' } },
           as: :json
      res = JSON.parse(response.body)
      expect(res).to eq({ 'email' => ["can't be blank"] })
    end
  end

  describe 'login' do
    it 'login successfully status 200' do
      user = FactoryBot.create(:user)
      post :login,
           params: { user: { email: user.email, password: user.password } },
           as: :json
      expect(response.status).to eq 200
      expect(response).to have_http_status(:ok)
    end

    it 'login successfully returns token' do
      user = FactoryBot.create(:user)
      post :login,
           params: { user: { email: user.email, password: user.password } },
           as: :json
      res = JSON.parse(response.body)
      expect(res).to include('auth_token')
    end

    it 'cant login if user does not exists returns status 401' do
      post :login,
           params: { user: { email: 'test@test.com', password: 'secret' } },
           as: :json
      expect(response.status).to eq 401
    end

    it 'cant login if user does not exists returns error' do
      post :login,
           params: { user: { email: 'test@test.com', password: 'secret' } },
           as: :json
      res = JSON.parse(response.body)
      expect(res['error']).to eq 'Invalid username/password'
    end

    it 'cant login if password incorrect returns error' do
      user = FactoryBot.create(:user)
      post :login,
           params: { user: { email: user.email, password: 'k' } },
           as: :json
      res = JSON.parse(response.body)
      expect(res['error']).to eq 'Invalid username/password'
    end
  end

  describe 'delete' do
    it 'deletes user successfully' do
      user = FactoryBot.create(:user)
      token = auth_tokens_for_user(user)
      request.headers.merge!({ 'Authorization' => token })
      delete :destroy, params: { id: user.id }
      expect(response.status).to eq 200
      expect(response).to have_http_status(:ok)
    end
  end
end
