require 'rails_helper'
  describe "Discoveries", type: :system do
    let(:discovery) { FactoryBot.build(:discovery) }
    let(:user) { FactoryBot.create(:user) }


    it "有効なデータを入力し、inidexページに表示される" do
      test_log_in(user)
      visit new_discovery_path
      fill_in "勉強して気づいたこと、発見したことをなんでも投稿しよう！", with: discovery.content
      click_button "Post"
      expect(page).to have_content "投稿する"
      expect(page).to have_content "#{discovery.content}"
      expect(page).to have_content "投稿しました"
    end

    it "関連づいたユーザーのプロフィール画像が表示されている" do
      test_log_in(user)
      visit new_discovery_path
      fill_in "勉強して気づいたこと、発見したことをなんでも投稿しよう！", with: discovery.content
      click_button "Post"
      expect(page).to have_selector ("img[src$='test.jpg']")
    end

    it "Discoveryのカウントが増える" do
      test_log_in(user)
      expect {
        create_one_discovery(discovery)
      }.to change(Discovery, :count).by(1)
    end

    it "無効なデータを入力し、indexページに表示されずオブジェクトの数が変わらない" do
      test_log_in(user)
      discovery.content = nil
      expect {
        create_one_discovery(discovery)
      }.to_not change(Discovery, :count)
    end

    it "newページにレンダーされる" do
      test_log_in(user)
      discovery.content = nil
      create_one_discovery(discovery)   # supportディレクトリ内に書いたメソッドを呼び出す
      expect(page).to have_css ".discovery-form"
      expect(page).to have_content "内容を入力してください"
    end

    it "クリックしたインスタンスと同じインスタンスがshowページで表示される" do
      test_log_in(user)
      visit new_discovery_path
      fill_in "勉強して気づいたこと、発見したことをなんでも投稿しよう！", with: "#{discovery.content}"
      click_button "Post"
      visit discoveries_path
      click_link "content-link", match: :first
      expect(page).to have_content "#{discovery.content}"
    end

    it "プロフィールをクリックしたらそのユーザーの詳細ページに行く" do
      discovery.save    # assotiationでuserと関連づいてるので、discoveryを作成した時点でuserが作成される
      test_log_in(user)
      visit discoveries_path
      click_link "discovery-profile-link"
      expect(current_path).to eq user_path(discovery.user)
    end

    it "ログインしてなければnewページを表示できないこと" do
      visit new_discovery_path
      expect(current_path).to eq login_path
    end

    it "削除リンクをクリックしたらdiscoveryが削除される" do
      test_log_in(user)
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

    it "ログインしていなければお気に入りボタンが表示されていないこと" do
      discovery.save
      visit discoveries_path
      expect(page).to_not have_css ".fa fa-star"
      visit discovery_path(discovery)
      expect(page).to_not have_css ".fa fa-star"
    end

    it "お気に入りボタンを押し、お気に入りに登録できる" do
      discovery.save
      test_log_in(user)
      visit discoveries_path
      expect {
        find('.i-favo').click
        sleep 0.5
      }.to change(Favorite, :count).by(1)
      expect(current_path).to eq discoveries_path
      expect(user.favorite?(discovery)).to be_truthy
    end

    it "お気に入り解除ボタンを押し、お気に入りの登録を解除できる" do
      discovery.save
      test_log_in(user)
      user.favo(discovery)
      visit discoveries_path
      expect {
        find('.i-unfavo').click
        sleep 0.5
      }.to change(Favorite, :count).by(-1)
      expect(current_path).to eq discoveries_path
      expect(user.favorite?(discovery)).to_not be_truthy
    end

    it "discoveryのshowページからコメントをお気に入り登録できる" do
      comment = FactoryBot.create(:comment)
      test_log_in(user)
      visit discovery_path(comment.discovery)
      expect {
        page.all(".i-favo")[1].click
        sleep 0.5
      }.to change(Favorite, :count).by(1)
      expect(current_path).to eq discovery_path(comment.discovery)
      expect(user.favorite_comment?(comment)).to be_truthy
    end

    it "discoveryのshowページからコメントのお気に入りを解除できる" do
      comment = FactoryBot.create(:comment)
      test_log_in(user)
      user.favorite_comment(comment)
      visit discovery_path(comment.discovery)
      expect {
        find(".i-unfavo").click
        sleep 0.5
      }.to change(Favorite, :count).by(-1)
      expect(current_path).to eq discovery_path(comment.discovery)
      expect(user.favorite_comment?(comment)).to_not be_truthy
    end

  end
