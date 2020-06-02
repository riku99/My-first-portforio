require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:second_user) { FactoryBot.create(:user, :second_user) }

  before do
    @base_title = "TOEICer Hiroba"
  end

  describe "GET /new" do
    it "returns http success" do
      get "/users/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST users_psth" do
    context "有効なデータの場合" do
      it "ログイン状態になる" do
        # .attributes_forは引数のファクトリの属性とその値をハッシュとして作成する
        post users_path, params: { user: FactoryBot.attributes_for(:user) }
        expect(is_logged_in?).to be_truthy  #ログイン状態になっているかテスト
      end
    end
  end

  it "admin属性が変更できないこと" do
    second_user.save
    post login_path, params: { session: FactoryBot.attributes_for(:user, :second_user) }
    patch user_path(second_user), params: { user: FactoryBot.attributes_for(:user, :second_user, admin: true)}
    expect(second_user.admin?).to_not be_truthy
  end

  it "admin属性がfalseであるユーザーはユーザーを削除できないこと" do
    user.save
    second_user.save
    log_in_as_second_user
    expect {
      delete user_path(user)
    }.to_not change(User, :count)
  end
end
