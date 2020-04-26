require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    @base_title = "TOEICer Hiroba"
  end

  describe "GET /new" do
    it "returns http success" do
      get "/users/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit_user_path" do
    it "正しいレスポンスを返す" do
      get edit_user_path(user)
      expect(response).to have_http_status(:success)
      assert_select "title", "Edit-profile | #{@base_title}"
    end
  end

  describe "PATCH user_path" do
    context "有効なユーザの場合" do
      it "showにリダイレクトされること" do
        patch user_path(user), params: {user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to user
      end
    end
  end

  describe "GET user_path" do
    it "正しいレスポンスを返す" do
      get user_path(user)
      expect(response).to have_http_status(:success)
      assert_select "title", "Show-profile | #{@base_title}"
    end
  end
end