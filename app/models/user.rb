class User < ApplicationRecord
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }   # 大文字小文字を区別せずにuniqunessをtrueにする
  validates :acount_id, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :introduce, length: { maximum: 140 }

  has_secure_password
  # has_secure_passwordは新しくレコードを追加する時のみpresenceが適用される
  # そのためupdateした際などで更新した際は適用されないため、validatesで記述する
  # allow_nilはupdateの際はpasswordを送らなくてもいいようにする
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Userひとつに1つの画像を紐付けること、その画像をUserからimageと呼ぶこと(インスタンスメソッド)を指定
  has_one_attached :image
end
