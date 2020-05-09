require 'rails_helper'
  describe "Discoveries", type: :system do
    let(:discovery) { FactoryBot.build(:discovery) }
    let(:user) { FactoryBot.build(:user) }


    it "有効なデータを入力し、inidexページに表示される" do
      user.save
      test_log_in
      visit new_discovery_path
      fill_in "勉強して気づいたこと、発見したことをなんでも投稿しよう！", with: discovery.content
      click_button "Post"
      expect(page).to have_content "投稿する"
      expect(page).to have_content "#{discovery.content}"
      expect(page).to have_content "投稿しました"
    end

    it "関連づいたユーザーのプロフィール画像が表示されていること" do
      user.save
      test_log_in
      visit new_discovery_path
      fill_in "勉強して気づいたこと、発見したことをなんでも投稿しよう！", with: discovery.content
      click_button "Post"
      expect(page).to have_selector ("img[src$='test.jpg']")
    end

    it "Discoveryのカウントが増える" do
      user.save
      test_log_in
      expect {
        create_one_discovery(discovery)
      }.to change(Discovery, :count).by(1)
    end

    it "無効なデータを入力し、indexページに表示されずオブジェクトの数が変わらない" do
      user.save
      test_log_in
      discovery.content = nil
      expect {
        create_one_discovery(discovery)
      }.to_not change(Discovery, :count)
    end

    it "newページにレンダーされる" do
      user.save
      test_log_in
      discovery.content = nil
      create_one_discovery(discovery)   # supportディレクトリ内に書いたメソッドを呼び出す
      expect(page).to have_css ".discovery-form"
      expect(page).to have_content "内容を入力してください"
    end

    it "クリックしたインスタンスと同じインスタンスがshowページで表示される" do
      user.save
      test_log_in
      visit new_discovery_path
      fill_in "勉強して気づいたこと、発見したことをなんでも投稿しよう！", with: "#{discovery.content}"
      click_button "Post"
      visit discoveries_path
      click_link "content-link", match: :first
      expect(page).to have_content "#{discovery.content}"
    end

    it "プロフィールをクリックしたらそのユーザーの詳細ページに行くこと" do
      discovery.save    # assotiationでuserと関連づいてるので、discoveryを作成した時点でuserが作成される
      test_log_in
      visit discoveries_path
      click_link "discovery-profile-link"
      expect(current_path).to eq user_path(discovery.user)
    end

    it "ログインしてなければnewページを表示できないこと" do
      visit new_discovery_path
      expect(current_path).to eq login_path
    end

    it "削除リンクをクリックしたらdiscoveryが削除されること" do
      user.save
      test_log_in
      visit new_discovery_path
      fill_in "勉強して気づいたこと、発見したことをなんでも投稿しよう！", with: "#{discovery.content}"
      click_button "Post"
      click_link "content-link"
      expect(page).to have_selector "a[data-method=delete]", text: "削除する"
      expect {
        click_link "削除する"
        page.driver.browser.switch_to.alert.accept
        visit current_path    #一旦アプリを更新
      }.to change(Discovery, :count).by(-1)
    end
  end
