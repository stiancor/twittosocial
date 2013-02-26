class User < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessible :name, :email, :password, :password_confirmation, :username
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { |user| user.email = user.email.downcase
                       user.username = user.username.downcase}
  before_save :create_remember_token

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  VALID_USERNAME_REGEX = /\A\w+\z/
  validates :username, presence: true, length: {maximum: 15, minimum: 2}, format: {with: VALID_USERNAME_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}
  validates :password_confirmation, presence: true

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def likes?(micropost)
    likes.find_by_micropost_id(micropost.id)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  mapping do
    indexes :id, :type => 'string', :index => :not_analyzed
    indexes :name
    indexes :username
    indexes :email
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
