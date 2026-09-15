require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  let!(:user) {create(:user) }
  let!(:todo){create(:todo, user: user, created_by: user.id.to_s)}
  let!(:items) {create_list(:item, 5, todo: todo)}
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }
  let(:token){JsonWebToken.encode(user_id: user.id.to_s)}
  let(:headers) {{'Authorization' => "Bearer #{token}", 'ACCEPT' => 'application/json'}}

  describe 'GET /todos/:todo_id/items' do
    before {get "/todos/#{todo_id}/items",headers: headers}

    context 'when todo exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns all items' do
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
    context 'when todo does not exist' do
      let(:todo_id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  describe 'GET /todos/:todo_id/items/:id' do
    before {get "/todos/#{todo_id}/items/#{id}", headers: headers}
    context 'when item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the item' do
        expect(JSON.parse(response.body)['id']).to eq(id)
      end
    end
    context 'when item does not exist' do
      let(:id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  describe 'POST /todos/:todo_id/items' do
    let(:valid_attributes) {{name: 'Buy milk', done: false}}
    context 'when request attributes are valid' do
      before {post "/todos/#{todo_id}/items", params: valid_attributes, headers: headers}

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    context 'when request attributes are invalid' do
      before {post "/todos/#{todo_id}/items", params: {name: ""}, headers: headers, as: :json}
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
  describe 'PUT /todos/:todo_id/items/:id' do
    let(:valid_attributes) {{name: 'Buy organic milk'}}
    before {put "/todos/#{todo_id}/items/#{id}", params: valid_attributes, headers: headers, as: :json}
    context 'when item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
  describe 'DELETE /todos/:todo_id/items/:id' do
    before {delete "/todos/#{todo_id}/items/#{id}", headers: headers}
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
