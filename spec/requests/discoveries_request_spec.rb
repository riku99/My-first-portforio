require 'rails_helper'

RSpec.describe "Discoveries", type: :request do
  let(:discovery) { FactoryBot.build(:discovery) }
  let(:user) { FactoryBot.build(:user) }

  it "ログインしてなければDisicoveryを作成できないこと" do
    post discoveries_path
    expect(response).to redirect_to login_path
  end

  it "ログインしてなければDiscoveryを削除できないこと" do
    discovery.save
    expect {
      delete discovery_path(discovery)
    }.to_not change(Discovery, :count)
  end

  it "ログインしているユーザーが違う場合は削除できないこと" do
    discovery.save    # assosiationされてるユーザーも作成
    #expect(discovery.user.acount_id).to eq "riku1"
    user.save     #assotiationされていないユーザーを作成
    #expect(user.acount_id).to eq "riku2"
    post login_path, params: { session: {acount_id: user.acount_id, password: user.password}}
    is_logged_in?
    expect {
      delete discovery_path(discovery)
    }.to_not change(Discovery, :count)
  end
end
