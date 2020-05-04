require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { FactoryBot.attributes_for(:user) }

  describe "GET /new" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "destroy" do
    before do
      post users_path, params: { user: user }
    end
    it "ログイン状態じゃなくなる" do
       delete logout_path(user)
       expect(is_logged_in?).to_not be_truthy
    end
  end
end
