# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  email            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  password_digest  :string(255)
#  remember_token   :string(255)
#  admin            :boolean          default(FALSE)
#  age              :string(255)
#  birth_date       :date
#  height           :float
#  cause            :string(255)
#  actual_weight    :float
#  goal_weight      :float
#  start_date       :date
#  goal_date        :date
#  prize            :string(255)
#  provider         :string(255)
#  uid              :string(255)
#  oauth_token      :string(255)
#  oauth_expires_at :datetime
#  image_url        :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :birth_date, :start_date, :goal_date, :height,
    :cause, :actual_weight, :goal_weight, :prize, :password, :password_confirmation

  # has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  # before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    # uniqueness: { case_sensitive: false }
  # validates :password, length: { minimum: 6 }
  # validates :password_confirmation, presence: true

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.image_url = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
