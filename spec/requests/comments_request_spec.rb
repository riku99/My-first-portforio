require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:comment) { FactoryBot.create(:comment) }

  it "ログインしていなければコメントを削除できないこと" do
    user
    comment
    expect {
      delete comment_path(comment)
    }.to_not change(Comment, :count)
  end

  it "違うユーザーのコメントは削除できないこと" do
    post login_path, params: { session: {acount_id: user.acount_id, password: user.password}}
    is_logged_in?
    comment
    expect {
      delete comment_path(comment)
    }.to_not change(Comment, :count)
  end
end
