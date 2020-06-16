require 'rails_helper'

RSpec.describe "Discoveries", type: :request do
  let!(:discovery) { FactoryBot.create(:discovery) }
  let!(:user) { FactoryBot.create(:user) }

  it "ログインしてなければDisicoveryを作成できないこと" do
    post discoveries_path
    expect(response).to redirect_to login_path
  end

  it "ログインしてなければDiscoveryを削除できないこと" do
    expect {
      delete discovery_path(discovery)
    }.to_not change(Discovery, :count)
  end

  it "ログインしているユーザーが違う場合は削除できないこと" do
    post login_path, params: { session: {acount_id: user.acount_id, password: user.password}}
    expect {
      delete discovery_path(discovery)
    }.to_not change(Discovery, :count)
  end
end
