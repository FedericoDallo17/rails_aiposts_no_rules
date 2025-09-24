require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'basic functionality' do
    it 'can be created with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'requires first_name' do
      user = build(:user, first_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it 'requires last_name' do
      user = build(:user, last_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to include("can't be blank")
    end

    it 'requires username' do
      user = build(:user, username: nil)
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'requires email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'has unique username' do
      create(:user, username: 'testuser')
      user = build(:user, username: 'testuser')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("has already been taken")
    end

    it 'has unique email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it 'returns full name' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end

    it 'can follow another user' do
      user1 = create(:user)
      user2 = create(:user)
      user1.follow(user2)
      expect(user1.following?(user2)).to be true
    end

    it 'cannot follow itself' do
      user = create(:user)
      user.follow(user)
      expect(user.following?(user)).to be false
    end
  end
end
