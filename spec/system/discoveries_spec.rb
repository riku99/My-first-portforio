require 'rails_helper'
  describe "Discoveries", type: :system do
    let(:discovery) { FactoryBot.build(:discovery) }



    it "有効なデータを入力し、inidexページに表示される" do
      visit new_discovery_path
      fill_in "勉強して気づいたこと、発見したことをなんでも投稿しよう！", with: discovery.content
      click_button "Post"
      expect(page).to have_content "投稿する"
      expect(page).to have_content "#{discovery.content}"
      expect(page).to have_content "投稿しました"
    end

    it "Discoveryのカウントが増える" do
      expect {
        create_one_discovery(discovery)
      }.to change(Discovery, :count).by(1)
    end

    it "無効なデータを入力し、indexページに表示されずオブジェクトの数が変わらない" do
      discovery.content = nil
      expect {
        create_one_discovery(discovery)
      }.to_not change(Discovery, :count)
    end

    it "newページにレンダーされる" do
      discovery.content = nil
      create_one_discovery(discovery)   # supportディレクトリ内に書いたメソッドを呼び出す
      expect(page).to have_css ".discovery-form"
      expect(page).to have_content "内容を入力してください"
    end

    it "クリックしたインスタンスと同じインスタンスがshowページで表示される" do
      visit new_discovery_path
      fill_in "勉強して気づいたこと、発見したことをなんでも投稿しよう！", with: "#{discovery.content}"
      click_button "Post"
      visit discoveries_path
      click_link "content-link", match: :first
      expect(page).to have_content "#{discovery.content}"
    end
  end
