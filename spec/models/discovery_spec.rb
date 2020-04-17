require 'rails_helper'

RSpec.describe Discovery, type: :model do
  describe "Discovery" do
    let(:discovery) { FactoryBot.create(:discovery) }
    let(:discovery_two) { FactoryBot.create(:discovery, id: 2) }

    it "contentが入力されていれば有効であること" do
      # contentの入った状態でnew
      discovery = FactoryBot.build(:discovery)
      # expectでvalidかどうか確認
      expect(discovery).to be_valid
    end
    it "contentの中身がなければ無効であること" do
      # contentのないdiscoveryをnew
      discovery = FactoryBot.build(:discovery, content: nil)
      # valid?メソッドで有効化を確認
      discovery.valid?
      # expectでエラーメッセージがインスタンスに入ったかを確認
      expect(discovery.errors[:content]).to include("を入力してください")
    end

    it "150文字以上なら無効であること" do
      discovery = FactoryBot.build(:discovery, content: "a" * 151)
      expect(discovery).to_not be_valid
    end

    it "インスタンスが日付を基準に降順に表示" do
      discovery
      discovery_two
      expect(Discovery.count).to eq 2
      expect(Discovery.all.to_a).to eq [discovery_two, discovery]
    end
  end
end
