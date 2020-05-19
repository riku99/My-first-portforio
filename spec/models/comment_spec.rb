require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryBot.create(:comment) }

  it "contentがなければ無効であること" do
    comment.content = nil
    #puts comment.user.inspect   # 関連付けを確認。inspectはオブジェクトを読める形式にした文字列にしている。
    #puts comment.discovery.inspect
    expect(comment).to_not be_valid
  end

  it "contentが151文字以上なら無効であること" do
    comment.content = "a" * 151
    expect(comment).to_not be_valid
  end

  it "作成日降順に取得されること" do
    comment
    second_comment = FactoryBot.create(:comment)
    expect(Comment.all.to_a).to eq [second_comment, comment]
  end

end
