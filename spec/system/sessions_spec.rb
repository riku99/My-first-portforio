require 'rails_helper'
  describe "Sessions", type: :system do
    let(:user) { FactoryBot.create(:user) }


    it "無効なデータを入れて、ログインされない" do
      visit login_path
      fill_in "User_id", with: user.acount_id
      fill_in "Password", with: "invalid_password"
      click_button "Login"
      expect(page).to have_content "User_idまたはpasswordが正しくありません"
    end

    it "有効なデータを入れ、ログインする" do
      test_log_in(user)
      expect(current_path).to eq user_path(user)
      expect(page).to have_css ".menu_button"
    end

    it "ログインを要求され、ログイン後に表示させたかったページになる" do
      visit edit_user_path(user)
      expect(current_path).to eq login_path
      test_log_in(user)
      expect(current_path).to eq edit_user_path(user)
    end

    it "session用cookieがない場合はログイン状態になっていない" do
      visit root_path
      expect(page).to have_content "ログイン"
    end

    it "永続cookieがある場合はログイン状態になること" do
      test_log_in(user)
      expect(page).to have_css ".menu_button"
      #show_me_the_cookies
      expire_cookies
      #show_me_the_cookies
      visit current_path
      #show_me_the_cookies
      expect(page).to have_css ".menu_button"
    end


    it "ログアウトリンクをクリックし、ログアウトされる", retry: 5 do
      visit root_path
      click_link "ログイン"
      fill_in "User_id", with: user.acount_id
      fill_in "Password", with: user.password
      click_button "Login"
      expect(page).to have_css ".menu_button"
      find(".menu_button").click
      click_link "Logout"
      page.driver.browser.switch_to.alert.accept    # リンクを押したときに出るalertのOKを押す
      expect(current_path).to eq root_path
      expect(page).to have_content "ログイン"
    end

    it "２つタブでログインしていて、片方をログアウトさせた後もう片方をログアウトさせてもエラーにならない" do
      test_log_in(user)
      within_window open_new_window do    # 新しいタブを開く
        test_log_in(user)
        find(".menu_button").click
        click_link "Logout"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "ログイン"
    end
      # タブを最初のものに戻す
      switch_to_window windows[0]
      find(".menu_button").click
      click_link "Logout"
      page.driver.browser.switch_to.alert.accept
      expect(current_path).to eq root_path
    end
  end
