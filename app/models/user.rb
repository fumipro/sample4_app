class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token
  # :activation_token

  # before_save { email.downcase! }
  # before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンがダイジェストと一致したらtrueを返す
  # def authenticated?(attribute, token)
  #   digest = send("#{attribute}_digest")
  #   return false if digest.nil?
  #   BCrypt::Password.new(digest).is_password?(token)
  # end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  # アカウントを有効にする
  # def activate
  #   update_attribute(:activated,    true)
  #   update_attribute(:activated_at, Time.zone.now)
  # end

  # 有効化用のメールを送信する
  # def send_activation_email
  #   UserMailer.account_activation(self).deliver_now
  # end

  def feed
    Micropost.where("user_id = ?", id)
  end

  private

  # メールアドレスをすべて小文字にする
  # def downcase_email
  #   self.email = email.downcase
  # end

  # 有効化トークンとダイジェストを作成および代入する
  # def create_activation_digest
  #   self.activation_token = User.new_token
  #   self.activation_digest = User.digest(activation_token)
  # end

  # test "associated microposts should be destroyed" do
  #   @user.save
  #   @user.microposts.create!(content: "Lorem ipsum")
  #   assert_difference 'Micropost.count', -1 do
  #     @user.destroy
  #   end
  # end
end
