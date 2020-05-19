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
  end
