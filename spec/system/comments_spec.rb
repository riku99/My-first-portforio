require 'rails_helper'
  describe "Comments", type: :system do
    let(:user) { FactoryBot.create(:user) }
    let(:discovery) { FactoryBot.create(:discovery) }

    it "ユーザーがコメントを投稿し、表示される" do
      test_log_in(user)
      discovery
      visit discoveries_path
      find(".fa-comment").click
      expect(current_path).to eq new_comment_path
      fill_in "コメントをしよう！", with: "test comment"

      expect {
        click_button "post"
      }.to change(Comment, :count).by(1)
      expect(current_path).to eq discovery_path(discovery)
      expect(page).to have_content "test comment"
    end

    it "ログインしていない場合はコメントを作成できない" do
      discovery
      visit new_comment_path
      expect(current_path).to eq login_path
    end

    it "ログイン済みでかつコメントがそのユーザーのコメントの場合削除できる" do
      c_user = FactoryBot.create(:user, :with_comment)
      discovery = c_user.comments.first.discovery
      #puts c_user.comments.inspect
      #puts c_user.comments.first.discovery.inspect
      test_log_in(c_user)
      visit discoveries_path
      click_link "content-link"
      click_link "comment-content-link"
      expect {
        click_link "削除する"
        page.driver.browser.switch_to.alert.accept
        visit current_path  # page.driverのあとは更新必要
      }.to change(Comment, :count).by(-1)
      expect(current_path).to eq discovery_path(discovery)
    end

    it "コメントのshow画面からコメントをお気に入り登録できる", retry: 3 do  # retryでランダムに落ちるテストを数回実行
      comment = FactoryBot.create(:comment)
      test_log_in(user)
      visit discovery_path(comment.discovery)
      click_link "comment-content-link"
      expect {
        find(".c-favo").click
        expect(current_path).to eq comment_path(comment)
      }.to change(Favorite, :count).by(1)
      expect(user.favorite_comment?(comment)).to be_truthy
    end

    it "コメントのshow画面からコメントのお気に入りを解除できる", retry: 3 do
      comment = FactoryBot.create(:comment)
      test_log_in(user)
      user.favorite_comment(comment)
      visit discovery_path(comment.discovery)
      click_link "comment-content-link"
      expect {
        find(".c-unfavo").click
      }.to change(Favorite, :count).by(-1)
      expect(current_path).to eq comment_path(comment)
      expect(user.favorite_comment?(comment)).to_not be_truthy
    end

    it "コメントに対してコメントができ、コメントされた方のshowページに表示される" do
      comment = FactoryBot.create(:comment)
      test_log_in(user)
      visit discoveries_path
      click_link "content-link"
      visit current_path    #なぜか一旦更新しないとコメントを見つけられないので更新
      page.all(".fa-comment")[1].click
      fill_in "コメントをしよう！", with: "コメント"
      expect {
        click_button "post"
      }.to change(Comment, :count).by(1)
      expect(current_path).to eq comment_path(comment)
      expect(page).to have_content "コメント"
    end
  end
