require 'rails_helper'
describe "Users", type: :system do
  let(:user) { FactoryBot.build(:user) }
  let(:second_user) { FactoryBot.build(:user, :second_user) }

  it "有効なデータを入力し、ユーザーが作成され、表示されるリンクが変わる" do
    visit new_user_path
    within '.header-link-box' do
      expect(page).to have_content "ログイン"
      expect(page).to_not have_content "ログアウト"
    end
    expect {
      fill_in "User_id", with: user.acount_id
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      fill_in "Confirmation", with: user.password_confirmation
      click_button "登録する"
    }.to change(User, :count).by(1)
    expect(page).to have_content "アカウントを登録しました"
    user = User.last
    expect(current_path).to eq user_path(user)
    # header-link-boxの中の内容が変わっているかテスト
    within '.header-link-box' do
      expect(page).to_not have_content "ログイン"
      expect(page).to have_content "ログアウト"
    end
  end

  it "無効なデータを入力し、ユーザが作成されず、表示されるリンクが変わらない" do
    visit new_user_path
    within '.header-link-box' do
      expect(page).to have_content "ログイン"
      expect(page).to_not have_content "ログアウト"
    end
    expect {
      fill_in "User_id", with: user.acount_id
      fill_in "Email", with: nil
      fill_in "Password", with: user.password
      fill_in "Confirmation", with: user.password_confirmation
      click_button "登録する"
    }.to_not change(User, :count)
    expect(page).to have_css '.errors'
    within '.header-link-box' do
      expect(page).to have_content 'ログイン'
      expect(page).to_not have_content 'ログアウト'
    end
  end


  it "showページで正しい値、デフオルトの画像が表示されている" do
    user.image = nil
    user.save
    visit user_path(user)
    expect(page).to have_content user.name
    expect(page).to have_content user.acount_id
    expect(page).to have_css '.no-image'
  end

  it "管理者ユーザは他のユーザを削除することができること" do
    user.save
    second_user.save
    test_log_in
    visit user_path(second_user)
    expect {click_link "ユーザーを削除"
            page.driver.browser.switch_to.alert.accept
            expect(current_path).to eq root_path
          }.to change(User, :count).by(-1)
  end

  it "画像がアップロードされていたら、その画像が表示されている" do
    user.save
    visit user_path(user)
    expect(page).to have_css '.image'
  end

  it "編集で有効なデータを入力し、更新される" do
    user.image = nil
    user.save #URLでuserのidを使うのでDBに保存されてる必要がある
    test_log_in
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

  it "編集ページで無効なデータを入力し、更新されないこと" do
    user.save
    test_log_in
    visit user_path(user)
    click_link "プロフィールを編集"
    fill_in "Name", with: user.name
    fill_in "User_id", with: ""
    fill_in "Score", with: user.score
    fill_in "Target score", with: user.target_score
    fill_in "Introduce", with: user.introduce
    click_button "Update"
    expect(user.reload.name).to_not eq ""
    expect(page).to have_css '.errors'
  end

  it "編集ページで画像を削除できること" do
    user.save
    test_log_in
    visit edit_user_path(user)
    click_link "プロフィール画像を削除"
    page.driver.browser.switch_to.alert.accept    # リンクを押したときに出るalertのOKを押す
    click_button "Update"
    expect(page).to have_css ".no-image"
    expect(page).to_not have_css ".image"
  end

  it "ログインしてるユーザーでなければ編集できないこと" do
    user.save
    second_user.save
    test_log_in
    visit edit_user_path(second_user)
    expect(current_path).to eq root_path
    expect(page).to have_content "他のユーザーは編集できません"
  end

  it "showページでユーザーをフォローしていない場合はフォローボタンが表示され、フォローできること" do
    user.save
    second_user.save
    test_log_in
    visit user_path(second_user)
    expect {
      click_button "フォローする"
      expect(current_path).to eq user_path(second_user)
    }.to change(Relationship, :count).by(1)
    expect(user.following?(second_user)).to be_truthy
  end

  it "showページでユーザーをフォローしている場合はフォロー中ボタンが表示され、フォロー解除できること" do
    user.save
    second_user.save
    test_log_in
    user.follow(second_user)
    visit user_path(second_user)
    expect {
      click_button "フォロー中"
      expect(current_path).to eq user_path(second_user)
    }.to change(Relationship, :count).by(-1)
    expect(user.following?(second_user)).to_not be_truthy
  end

  it "フォロー中一覧ページでフォロー中のユーザーが表示されていること" do
    user.save
    second_user.save
    test_log_in
    user.follow(second_user)
    visit user_path(user)
    click_link "following-count"
    expect(page).to have_selector "img[src$='test.jpg']"
    expect(page).to have_content second_user.name
    expect(page).to have_content second_user.acount_id
  end

  it "ログインしていなければfollowingページを表示できず、ログイン画面にリダイレクトされること" do
    user.save
    second_user.save
    visit user_path(user)
    click_link "following-count"
    visit current_path    # リロードする
    expect(current_path).to eq login_path
  end

  it "フォロー一覧ページでフォローしてないユーザーをフォローでき、ページを移動しないこと" do
    user.save
    second_user.save
    third_user = FactoryBot.create(:user)
    test_log_in
    second_user.follow(third_user)
    visit user_path(second_user)
    click_link "following-count"
    expect {
      click_button "フォローする"
      expect(current_path).to eq following_user_path(second_user)
      expect(page).to have_button "フォロー中"
    }.to change(Relationship, :count).by(1)
  end

  it "フォロー一覧ページでフォローしているユーザーをアンフォローでき、ページを移動しないこと" do
    user.save
    second_user.save
    third_user = FactoryBot.create(:user)
    test_log_in
    user.follow(third_user)
    second_user.follow(third_user)
    visit user_path(second_user)
    click_link "following-count"
    expect {
      click_button "フォロー中"
      expect(current_path).to eq following_user_path(second_user)
      expect(page).to have_button "フォローする"
    }.to change(Relationship, :count).by(-1)
  end
end
