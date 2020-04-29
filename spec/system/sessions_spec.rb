require 'rails_helper'
  describe "Sessions", type: :system do
    let(:user) { FactoryBot.build(:user) }

    describe "POST /login" do
      context "無効なデータの場合" do
        it "ログインしない" do
          visit login_path
          fill_in "User_id", with: user.acount_id
          fill_in "Password", with: "invalid_password"
          click_button "Login"
          expect(page).to have_content "User_idまたはpasswordが正しくありません"
        end
      end
    end
  end
