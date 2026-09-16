require 'rails_helper'

RSpec.describe "Todos API", type: :request do
  let!(:user) {create(:user)}
  let!(:todos) {create_list(:todo, 5,user: user)}
  let!(:items) {create_list(:item, 3, todo: todos.first)}
  let(:token) {JsonWebToken.encode(user_id: user.id)}
  let(:todo_id) {todos.first.id}
  let(:headers) { { 'Authorization' => "Bearer #{token}", 'ACCEPT' => 'application/json'} }
  #GET /todos (List all todos and todo items)
  describe 'GET /todos' do
    before {get "/todos", headers: headers}
    it 'returns todos' do
      expect(response).to have_http_status(200)
    end
    it 'includes todo items in the response' do
      json_response = JSON.parse(response.body)
      first_todo = json_response.find{|t| t['id'] == todo_id}
      expect(first_todo['items']).not_to be_nil
      expect(first_todo['items'].count).to eq(3)
    end
  end

  describe 'GET /todos/:id when record belongs to another user' do
    let!(:other_user) {create(:user)}
    let(:other_token) {JsonWebToken.encode(user_id: other_user.id.to_s)}
    let(:other_headers) { { 'Authorization' => "Bearer #{other_token}", 'ACCEPT' => 'application/json'} }
    before {get "/todos/#{todo_id}", headers: other_headers}
    it 'returns status code 404' do
      expect(response).to have_http_status(404)
    end
  end
  describe 'PUT /todos/:id when record belongs to another user' do
    let!(:other_user) {create(:user)}
    let(:other_token) {JsonWebToken.encode(user_id: other_user.id.to_s)}
    let(:other_headers) { { 'Authorization' => "Bearer #{other_token}", 'ACCEPT' => 'application/json'} }
    before do
      put "/todos/#{todo_id}", headers: other_headers, params: {title: 'Hacked Title'}, as: :json
    end
    it 'returns status code 404 and does not update the record' do
      expect(response).to have_http_status(404)
      expect(todos.first.reload.title).not_to eq('Hacked Title')
    end
  end
  describe 'POST /todos' do
      before do
        post '/todos',
             params: { title: 'Learn RSpec' },
             headers: headers,
             as: :json
      end
      it 'creates a todo' do
        expect(response).to have_http_status(201)
      end
  end

  describe 'PUT /todos/:id' do
    let(:valid_attributes) {{title: 'Shopping'}}
    context 'when the record exists' do
      before {put "/todos/#{todo_id}", params: valid_attributes, headers: headers, as: :json}
      it 'updates the record' do
        expect(response).to have_http_status(200)
      end
    end
  end
  # DELETE /todos/:id (delete a todo and its items)
  describe 'DELETE /todos/:id' do
    it 'deletes the todo and its associated items' do
      expect{
        delete "/todos/#{todo_id}", headers: headers
      }.to change(Todo, :count).by(-1).and change(Item, :count).by(-3)

      expect(response).to have_http_status(204)
    end
  end

end


