require 'rails_helper'
describe "Users", type: :system do
  let(:user) { FactoryBot.build(:user) }

  describe "POST users" do
    context "有効なユーザーの場合" do
      it "作成される" do
        visit new_user_path
        expect {
          fill_in "Name", with: user.name
          fill_in "User_id", with: user.acount_id
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          fill_in "Confirmation", with: user.password_confirmation
          click_button "Signup"
          expect(page).to have_content "アカウントを登録しました"
        }.to change(User, :count).by(1)
      end

    end
    context "無効なユーザーの場合" do
      it "作成されない" do

        visit new_user_path
        expect {
          fill_in "Name", with: user.name
          fill_in "User_id", with: user.acount_id
          fill_in "Email", with: nil
          fill_in "Password", with: user.password
          fill_in "Confirmation", with: user.password_confirmation
          click_button "Signup"
        }.to_not change(User, :count)
        expect(page).to have_css '.errors'
      end
    end
  end

  describe "GET user_path" do
    context "画像がアップロードされていない時" do
      it "正しい値、デフオルトの画像が表示されている" do
        user.image = nil
        user.save
        visit user_path(user)
        expect(page).to have_content user.name
        expect(page).to have_content user.acount_id
        expect(page).to have_content user.score
        expect(page).to have_content user.target_score
        expect(page).to have_css '.no-image'
      end
    end
    context "画像がアップロードされている場合" do
      it "アップロードされた画像が表示されている" do
        user.save
        visit user_path(user)
        expect(page).to have_css '.image'
      end
    end
  end

  describe "PATCH user_path" do
    context "有効なユーザーの場合" do
      it "更新される" do
        user.image = nil
        user.save #URLでuserのidを使うのでDBに保存されてる必要がある
        visit user_path(user)
        click_link "プロフィールを編集"
        # make_visibleで非表示にされている要素を一時的に表示する
        attach_file "プロフィール画像を選択", "#{Rails.root}/spec/images/test.jpg", make_visible: true
        fill_in "Name", with: "yu-ri"
        fill_in "User_id", with: user.acount_id
        fill_in "Score", with: user.score
        fill_in "Target score", with: user.target_score
        fill_in "Introduce", with: user.introduce
        #execute_script('window.scrollBy(0,10000)') 下までスクロールする
        click_button "Update"
        expect(current_path).to eq user_path(user)
        expect(user.reload.name).to eq "yu-ri"
        expect(page).to have_content "yu-ri"
        expect(page).to have_css ".image"
        expect(page).to have_content "更新しました"
      end
    end
    context "無効なユーザーの場合" do
      it "更新されないこと" do
        user.save
        visit user_path(user)
        click_link "プロフィールを編集"
        fill_in "Name", with: ""
        fill_in "User_id", with: user.acount_id
        fill_in "Score", with: user.score
        fill_in "Target score", with: user.target_score
        fill_in "Introduce", with: user.introduce
        click_button "Update"
        expect(user.reload.name).to_not eq ""
        expect(page).to have_css '.errors'
      end
    end
  end
end
