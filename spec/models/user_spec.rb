require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:duplicate_acount_id_user) { FactoryBot.build(:user, :duplicate_acount_id_user) }
  let(:user_name_nil) { FactoryBot.build(:user, :name_nil) }
  let(:user_email_nil) { FactoryBot.build(:user, :email_nil) }
  let(:user_name_over) { FactoryBot.build(:user, :name_over_word) }
  let(:user_email_over) { FactoryBot.build(:user, :email_over_word) }

  it "name,email,acount_id,passwordがあれば有効であること" do
    expect(user).to be_valid
  end

  it "nameがなければ無効であること" do
    expect(user_name_nil).to_not be_valid
  end

  it "emailがなければ無効であること" do
    expect(user_email_nil).to_not be_valid
  end

  it  "nameが26文字以上なら無効であること" do
    expect(user_name_over).to_not be_valid
  end

  it "emailが256文字以上なら無効であること" do
    expect(user_email_over).to_not be_valid
  end

  it "emailが特定のフォーマットであれば有効であること" do
    valid_address = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_address.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect}が無効です" # expectの第2引数にエラーメッセージを追加
    end
  end

  it "emailが特定のフォーマット出なければ無効であること" do
    invalid_address = %W[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_address.each do |invalid_address|
      user.email = invalid_address
      expect(user).to_not be_valid, "#{invalid_address.inspect}が有効です"
    end
  end

  it "emailは大文字小文字を区別せず、DB上で一意であること" do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).to_not be_valid
  end

  it "acount_idがなければ無効であること" do
    user.acount_id = nil
    expect(user).to_not be_valid
  end

  it "acount_idが31文字以上なら無効であること" do
    user.acount_id = "r" * 31
    expect(user).to_not be_valid
  end

  it "acount_idは一意でなければ無効であること" do
    user.save
    expect(duplicate_acount_id_user).to_not be_valid
  end

  it "passwordが6文字未満なら無効であること" do
    user.password = user.password_confirmation = "a" * 5
    expect(user).to_not be_valid
  end

end
