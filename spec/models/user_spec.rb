require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_length_of(:first_name).is_at_least(2).is_at_most(50) }
    it { should validate_length_of(:last_name).is_at_least(2).is_at_most(50) }
    it { should validate_length_of(:username).is_at_least(3).is_at_most(30) }
    it { should validate_length_of(:bio).is_at_most(500) }
    it { should validate_length_of(:location).is_at_most(100) }
  end

  describe 'associations' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:liked_posts).through(:likes).source(:post) }
    it { should have_many(:follows_as_follower).class_name('Follow').with_foreign_key('follower_id').dependent(:destroy) }
    it { should have_many(:follows_as_following).class_name('Follow').with_foreign_key('following_id').dependent(:destroy) }
    it { should have_many(:following).through(:follows_as_follower).source(:following) }
    it { should have_many(:followers).through(:follows_as_following).source(:follower) }
    it { should have_many(:notifications).dependent(:destroy) }
    it { should have_one_attached(:profile_picture) }
    it { should have_one_attached(:cover_picture) }
  end

  describe 'methods' do
    let(:user) { create(:user) }

    it 'returns full name' do
      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end

    it 'can follow another user' do
      other_user = create(:user)
      user.follow(other_user)
      expect(user.following?(other_user)).to be true
    end

    it 'can unfollow another user' do
      other_user = create(:user)
      user.follow(other_user)
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be false
    end

    it 'cannot follow itself' do
      user.follow(user)
      expect(user.following?(user)).to be false
    end
  end
end
