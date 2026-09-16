require 'rails_helper'

RSpec.describe 'Authentication API', type: :request do
  let!(:user){create(:user)}
  let(:headers) {{'Authorization'=> "Bearer #{JsonWebToken.encode(user_id: user.id.to_s)}"}}
  describe 'POST /signup' do
    let(:valid_attributes) do
      { name: 'Test User', email: 'signup@example.com', password: 'password123', password_confirmation: 'password123' }
    end

    it 'creates a user and returns an authentication token' do
      post '/signup', params: valid_attributes, as: :json
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['auth_token']).not_to be_nil
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
      get '/auth/logout', headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end