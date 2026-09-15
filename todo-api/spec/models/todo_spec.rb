require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)

    end
    it 'has many items' do
      association = described_class.reflect_on_association(:items)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
  describe 'validations' do
    it 'is invalid without a title' do
      todo = Todo.new(title: nil, created_by: '1')
      expect(todo).not_to be_valid
      expect(todo.errors[:title]).to include("can't be blank")
    end
    it 'is invalid without a created_by' do
      todo = Todo.new(title: 'Buy Groceries', created_by: '')
      expect(todo).not_to be_valid
      expect(todo.errors[:created_by]).to include("can't be blank")
    end
  end
end
