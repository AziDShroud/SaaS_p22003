require 'rails_helper'

RSpec.describe 'Authentication API', type: :request do
  let!(:user){create(:user)}

  describe 'POST /signup' do
    context 'when valid request' do
      it 'creates a user and returns an authentication token' do
        post '/signup', params: {name: 'New User', email: 'new@example.com', password: 'password123'}
        expect(response).to have_http_status(:created)
        expect(json_response).to have_key('token')
      end
    end
  end

  describe 'POST /auth/login' do
    context 'when credentials are valid' do
      it 'returns an authentication token' do
        post '/auth/login',params:{email: user.email, password: user.password}
        expect(response).to have_http_status(:ok)
        expect(json_response).to have_key('token')
      end
    end
  end
  describe 'GET /auth/logout' do
    it 'returns a success message'do
      get '/auth/logout'
      expect(response).to have_http_status(:ok)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end