require 'rails_helper'
  describe "Comments", type: :system do
    let(:user) { FactoryBot.create(:user) }
    let(:discovery) { FactoryBot.create(:discovery) }

    it "ユーザーがコメントを投稿し、表示される" do
      test_log_in
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

    it "コメントのshow画面からコメントをお気に入り登録できる", focus: true, retry: 3 do  # retryでランダムに落ちるテストを数回実行
      comment = FactoryBot.create(:comment)
      test_log_in
      visit discovery_path(comment.discovery)
      click_link "comment-content-link"
      expect {
        find(".c-favo").click
        expect(current_path).to eq comment_path(comment)
      }.to change(Favorite, :count).by(1)
      expect(user.favorite_comment?(comment)).to be_truthy
    end

    it "コメントのshow画面からコメントのお気に入りを解除できる", focus: true, retry: 3 do
      comment = FactoryBot.create(:comment)
      test_log_in
      user.favorite_comment(comment)
      visit discovery_path(comment.discovery)
      click_link "comment-content-link"
      expect {
        find(".c-unfavo").click
      }.to change(Favorite, :count).by(-1)
      expect(current_path).to eq comment_path(comment)
      expect(user.favorite_comment?(comment)).to_not be_truthy
    end
  end
