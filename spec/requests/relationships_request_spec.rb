require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:second_user) { FactoryBot.create(:user, :second_user) }

  it "ログインしてなければユーザーをフォローできないこと" do
    expect {
      post relationships_path
      expect(response).to redirect_to login_path
    }.to_not change(Relationship, :count)
  end
end
