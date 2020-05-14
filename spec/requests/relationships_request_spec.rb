require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let(:user) { FactoryBot.build(:user) }
  let(:second_user) { FactoryBot.build(:user, :second_user) }

  it "ログインしてなければユーザーをフォローできないこと" do
    user.save
    second_user.save
    expect {
      post relationships_path
      expect(response).to redirect_to login_path
    }.to_not change(Relationship, :count)
  end

end
