require 'rails_helper'
describe "Users", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:second_user) { FactoryBot.create(:user, :second_user) }

  it "有効なデータを入力し、ユーザーが作成され、表示されるリンクが変わる" do
    user = FactoryBot.build(:user)
    visit new_user_path
    expect(page).to have_content "ログイン"
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
    expect(page).to have_css ".menu_button"
  end

  it "無効なデータを入力し、ユーザが作成されず、表示されるリンクが変わらない" do
    user = FactoryBot.build(:user)
    visit new_user_path
    expect(page).to have_content "ログイン"
    expect {
      fill_in "User_id", with: user.acount_id
      fill_in "Email", with: nil
      fill_in "Password", with: user.password
      fill_in "Confirmation", with: user.password_confirmation
      click_button "登録する"
    }.to_not change(User, :count)
    expect(page).to have_css '.errors'
    expect(page).to have_content "ログイン"
    expect(page).to_not have_css ".menu_button"
  end

  it "showページで正しい値、デフオルトの画像が表示されている" do
    user = FactoryBot.build(:user)
    user.image = nil
    user.save
    visit user_path(user)
    expect(page).to have_content user.name
    expect(page).to have_content user.acount_id
    expect(page).to have_css '.no-image'
  end

  it "管理者ユーザは他のユーザを削除することができること" do
    second_user.save
    test_log_in(user)
    visit user_path(second_user)
    expect {click_link "ユーザーを削除"
            page.driver.browser.switch_to.alert.accept
            expect(current_path).to eq root_path
          }.to change(User, :count).by(-1)
  end

  it "画像がアップロードされていたら、その画像が表示されている" do
    visit user_path(user)
    expect(page).to have_css '.image'
  end

  it "編集で有効なデータを入力し、更新される" do
    user.image = nil
    test_log_in(user)
    visit user_path(user)
    click_link "プロフィールを編集"
    # make_visibleで非表示にされている要素を一時的に表示する
    attach_file "プロフィール画像を選択", "#{Rails.root}/spec/images/test.jpg", make_visible: true
    fill_in "Name", with: "yu-ri"
    fill_in "User_id", with: user.acount_id
    fill_in "Introduce", with: user.introduce
    #execute_script('window.scrollBy(0,10000)') 下までスクロールする
    click_button "Update"
    expect(current_path).to eq user_path(user)
    expect(user.reload.name).to eq "yu-ri"
    expect(page).to have_content "yu-ri"
    expect(page).to have_css ".image"
    expect(page).to have_content "更新しました"
  end

  it "編集ページで無効なデータを入力し、更新されない" do
    test_log_in(user)
    visit user_path(user)
    click_link "プロフィールを編集"
    fill_in "Name", with: user.name
    fill_in "User_id", with: ""
    fill_in "Introduce", with: user.introduce
    click_button "Update"
    expect(user.reload.name).to_not eq ""
    expect(page).to have_css '.errors'
  end

  it "編集ページで画像を削除できること" do
    test_log_in(user)
    visit edit_user_path(user)
    click_link "プロフィール画像を削除"
    page.driver.browser.switch_to.alert.accept    # リンクを押したときに出るalertのOKを押す
    click_button "Update"
    expect(page).to have_css ".no-image"
    expect(page).to_not have_css ".image"
  end

  it "ログインしてるユーザーでなければ編集できないこと" do
    second_user.save
    test_log_in(user)
    visit edit_user_path(second_user)
    expect(current_path).to eq root_path
    expect(page).to have_css ".danger"
  end

  it "showページでユーザーをフォローしていない場合はフォローボタンが表示され、フォローできること" do
    using_wait_time(5) do
    second_user.save
    test_log_in(user)
    visit user_path(second_user)
    expect {
      click_button "フォローする"
      # ajaxの処理が完了するのをsleepで待つ
      sleep 0.5
    }.to change(Relationship, :count).by(1)
    expect(current_path).to eq user_path(second_user)
    expect(user.following?(second_user)).to be_truthy
  end
  end

  it "showページでユーザーをフォローしている場合はフォロー中ボタンが表示され、フォロー解除できること" do
    using_wait_time(5) do
    second_user.save
    test_log_in(user)
    user.follow(second_user)
    visit user_path(second_user)
    expect {
      click_button "フォロー中"
      sleep 0.5
    }.to change(Relationship, :count).by(-1)
    expect(current_path).to eq user_path(second_user)
    expect(user.following?(second_user)).to_not be_truthy
  end
  end

  it "フォロー中一覧ページ(followingページ)でフォロー中のユーザーが表示されていること" do
    second_user.save
    test_log_in(user)
    user.follow(second_user)
    visit user_path(user)
    click_link "following-count"
    expect(page).to have_selector "img[src$='test.jpg']"
    expect(page).to have_content second_user.name
    expect(page).to have_content second_user.acount_id
  end

  it "ログインしていなければfollowingページを表示できず、ログイン画面にリダイレクトされること" do
    second_user.save
    visit user_path(user)
    click_link "following-count"
    expect(page).to have_selector ".danger", text: "ログインしてください"
    expect(current_path).to eq login_path
  end

  it "フォロワー一覧ページ(followersページ)でフォロワーが表示される" do
    second_user.follow(user)
    test_log_in(user)
    click_link "follower-count"
    expect(page).to have_content second_user.name
    expect(page).to have_content second_user.acount_id
  end

  it "ログインしてなければfollowersページは表示されずログインページにリダイレクトされる" do
    second_user.follow(user)
    visit user_path(user)
    click_link "follower-count"
    expect(page).to have_selector ".danger", text: "ログインしてください"
    expect(current_path).to eq login_path
  end

  it "フォロー一覧ページでフォローしてないユーザーをフォローでき、ページを移動しないこと" do
    second_user.save
    third_user = FactoryBot.create(:user)
    test_log_in(user)
    second_user.follow(third_user)
    visit user_path(second_user)
    click_link "following-count"
    expect {
      click_button "フォローする"
      sleep 0.5
    }.to change(Relationship, :count).by(1)
    expect(current_path).to eq following_user_path(second_user)
  end

  it "フォロー一覧ページでフォローしているユーザーをアンフォローでき、ページを移動しないこと" do
    second_user.save
    third_user = FactoryBot.create(:user)
    test_log_in(user)
    user.follow(third_user)
    second_user.follow(third_user)
    visit user_path(second_user)
    click_link "following-count"
    expect {
      click_button "フォロー中"
      sleep 0.5
    }.to change(Relationship, :count).by(-1)
    expect(current_path).to eq following_user_path(second_user)
  end

  it "feedページで自分とフォローしているユーザーのDiscoveryが表示される" do
    test_log_in(user)
    discovery = FactoryBot.create(:discovery, user: user, content: "userの投稿です")
    user.follow(second_user)
    second_discovery = FactoryBot.create(:discovery, user: second_user, content: "second_userの投稿です")
    visit user_path(user)
    find(".menu_button").click
    click_link "Following User Posts"
    expect(page).to have_content "userの投稿です"
    expect(page).to have_content "second_userの投稿です"
  end

  it "ログインユーザーと違うユーザーのfeedページは表示できずにホーム画面にリダイレクトされる" do
    test_log_in(user)
    visit feed_user_path(second_user)
    expect(page).to have_css ".danger"
    expect(current_path).to eq root_path
  end
end
