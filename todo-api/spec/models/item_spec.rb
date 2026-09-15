require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it 'belongs to a todo' do
      association = described_class.reflect_on_association(:todo)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is invalid without a name' do
      item= Item.new(name: nil)
      expect(item).to_not be_valid
      expect(item.errors.full_messages).to include("Name can't be blank")
    end
  end
end
