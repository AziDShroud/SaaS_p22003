require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has many todos' do
      association = described_class.reflect_on_association(:todos)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
  describe 'validations' do
    it 'is invalid without a name' do
      user= User.new(name: nil, email:'user@example.com', password: 'password123')
      expect(user).to_not be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end
    it 'is invalid without an email' do
      user= User.new(name:"user",email: nil, password:'password123')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
    it 'is invalid without a password' do
      user = User.new(name: 'Test User', email: 'user@example.com', password: nil)
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end
  end
end
