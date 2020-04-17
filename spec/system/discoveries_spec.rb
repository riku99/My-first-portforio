require 'rails_helper'
  describe "Discoveries", type: :system do
    let(:discovery) { FactoryBot.build(:discovery) }

    describe "POST discoveries_path" do
      context "有効なインスタンスの場合" do
        it "inidexページに表示される" do
          visit new_discovery_path
          fill_in "Post anything you notice!", with: discovery.content
          click_button "Post"

          expect(page).to have_content "気づきをのせる"
          expect(page).to have_content "#{discovery.content}"
          expect(page).to have_content "投稿しました"
        end

        it "Discoveryのカウントが増える", focus: true do
          expect {
            create_one_discovery(discovery)
          }.to change(Discovery, :count).by(1)
        end
      end

      context "無効なインスタンスの場合" do
        it "Discoveryのカウントが変わらない" do
          discovery.content = nil

          expect {
            create_one_discovery(discovery)
          }.to_not change(Discovery, :count)
        end

        it "newページにレンダーされる" do
          discovery.content = nil
          create_one_discovery(discovery)   # supportディレクトリ内に書いたメソッドを呼び出す

          expect(page).to have_content "Post anything you notice!"
          expect(page).to have_content "内容を入力してください"
        end
      end
    end

    describe "GET discoveries/:id" do
      it "クリックしたインスタンスと同じインスタンスが表示される" do
        visit new_discovery_path
        fill_in "Post anything you notice!", with: "#{discovery.content}"
        click_button "Post"
        visit discoveries_path
        click_link "content-link", match: :first

        expect(page).to have_content "#{discovery.content}"
      end
    end
  end
