require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:relationship) { FactoryBot.build(:relationship) }
  let(:user) { FactoryBot.build(:user) }
  let(:second_user) { FactoryBot.build(:user, :second_user) }

  it "follower_idがない場合は無効であること" do
    relationship.follower_id = nil
    relationship.save
    expect(relationship).to_not be_valid
  end

  it "followed_idがばい場合は無効であること" do
    relationship.followed_id = nil
    relationship.save
    expect(relationship).to_not be_valid
  end

  it "followメソッドでfollowingの要素が加わること" do
    user.save
    second_user.save
    user.follow(second_user)
    expect(user.following?(second_user)).to be_truthy
  end

  it "unfollowメソッドでfollowingの要素が消されること" do
    user.save
    second_user.save
    user.follow(second_user)
    user.unfollow(second_user)
    expect(user.following?(second_user)).to_not be_truthy
  end

  it "followersでユーザーをフォローしている値を取り出せること" do
    user.save
    second_user.save
    user.follow(second_user)
    expect(second_user.followers.include?(user)).to be_truthy
  end
end
