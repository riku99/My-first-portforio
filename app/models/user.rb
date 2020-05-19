class User < ApplicationRecord
  # このモデル(User)のidを外部キーとして抱えるクラス(discovery)が存在し、そのレコードが複数登録可能であることを表す
  has_many :discoveries, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationship, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :followers, through: :passive_relationship

  has_many :favorites, dependent: :destroy

  # Favoriteでbelongs_to discoveryを指定することで取得したdiscovery_idがDiscoveryの主キーと関連する
  has_many :favo_discovery, through: :favorites, source: :discovery

  has_many :comments, dependent: :destroy

  # DBには保存されないがUserオブジェクトから呼び出せる仮想的な属性を設定
  attr_accessor :remember_token
  before_save { self.email = self.email.downcase }
  validates :name, length: { maximum: 25 }
  validates :acount_id, presence: true, length: { maximum: 30 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }   # 大文字小文字を区別せずにuniqunessをtrueにする
  validates :introduce, length: { maximum: 140 }

  has_secure_password

  # has_secure_passwordは新しくレコードを追加する時のみpresenceが適用される
  # そのためupdateした際などで更新した際は適用されないため、validatesで記述する
  # allow_nilはupdateの際はpasswordを送らなくてもいいようにする
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Userひとつに1つの画像を紐付けること、その画像をUserからimageと呼ぶこと(インスタンスメソッド)を指定
  has_one_attached :image

  # 渡された文字列のハッシュ値を返す
 def User.digest(string)
   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                 BCrypt::Engine.cost
   BCrypt::Password.create(string, cost: cost)
 end

  # トークンとなるランダムな文字列を返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # remember_digestにnew_tokenメソッドでのランダムな文字列を代入
  # メモリ上で代入されたのみでDBには保存されてないのでupdate_attributeを使って保存
  # 保存させる際はセキュリティのためにハッシュ化させたいのでUser.digestメソッドの戻り値を保存させる。
  def m_remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡された値がオブジェクトのremember_digestと一致するか確かめる

  # 異なるブラウザで同じuserでログインしていた場合、片方でログアウトするとuserのremember_digestがなくなる
  # もう片方のブラウザでアプリに入ると、永続cookieとremember_digestが一致するかこのメソッドで検証されるためエラーになるのでreturnを記述
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def m_forget
    update_attribute(:remember_digest, nil)
  end

  def follow(other_user)
    self.following << other_user
  end

  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    self.following.include?(other_user)
  end

  def favo(other_discovery)
    self.favo_discovery << other_discovery
  end

  def favorite?(other_discovery)
    self.favo_discovery.include?(other_discovery)
  end

  def unfavorite(other_discovery)
    self.favorites.find_by(discovery_id: other_discovery.id).destroy
  end

end
