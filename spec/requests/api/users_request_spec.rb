require 'rails_helper'

RSpec.describe "api/Users", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  it "userを取得すること" do
    post login_path, params: { session: {acount_id: user.acount_id, password: user.password } }
    get api_users_current_user_path
    json = JSON.parse(response.body)
    expect(response.status).to eq 200
    expect(json["id"]).to eq user.id
  end
end
