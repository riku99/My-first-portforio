require 'rails_helper'
  describe "Sessions", type: :system do
    let(:user) { FactoryBot.build(:user) }


    it "無効なデータを入れて、ログインされない" do
      visit login_path
      fill_in "User_id", with: user.acount_id
      fill_in "Password", with: "invalid_password"
      click_button "Login"
      expect(page).to have_content "User_idまたはpasswordが正しくありません"
    end

    it "有効なデータを入れ、ログインする" do
      user.save
      test_log_in
      expect(current_path).to eq user_path(user)
      expect(page).to have_content "ログアウト"
    end

    it "ログインを要求され、ログイン後に表示させたかったページになる" do
      user.save
      visit edit_user_path(user)
      expect(current_path).to eq login_path
      test_log_in
      expect(current_path).to eq edit_user_path(user)
    end

    it "session用cookieがない場合はログイン状態になっていない" do
      visit root_path
      expect(page).to have_content "ログイン"
    end

    it "永続cookieがある場合はログイン状態になること" do
      user.save
      test_log_in
      expect(page).to have_content "ログアウト"
      show_me_the_cookies
      expire_cookies
      show_me_the_cookies
      visit current_path
      show_me_the_cookies
      expect(page).to have_content "ログアウト"
    end


    it "ログアウトリンクをクリックし、ログアウトされる" do
      user.save
      visit root_path
      click_link "ログイン"
      fill_in "User_id", with: user.acount_id
      fill_in "Password", with: user.password
      click_button "Login"
      expect(page).to have_content "ログアウト"
      click_link "ログアウト"
      page.driver.browser.switch_to.alert.accept    # リンクを押したときに出るalertのOKを押す
      expect(current_path).to eq root_path
      expect(page).to have_content "ログイン"
    end

    it "２つタブでログインしていて、片方をログアウトさせた後もう片方をログアウトさせてもエラーにならない" do
      user.save
      test_log_in

      # 新しいタブを開く
      within_window open_new_window do
        test_log_in
        click_link "ログアウト"
        page.driver.browser.switch_to.alert.accept
      end

      # タブを最初のものに戻す
      switch_to_window windows[0]
      click_link "ログアウト"
      page.driver.browser.switch_to.alert.accept
      expect(current_path).to eq root_path
    end
  end
