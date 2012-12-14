class Micropost < ActiveRecord::Base
  attr_accessible :content, :admin_message
  belongs_to :user
  has_many :likes
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 250}

  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by(user)
    followed_user_ids = "select followed_id from relationships where follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) or user_id = :user_id",
          {user_id: user.id})
  end

  def like!(user)
    like = likes.new(micropost_id: self.id)
    like.user_id = user.id
    like.save
    like
  end

  def unlike!(user)
    likes.find_by_user_id(user.id).destroy
  end

  def like?(user)
    likes.find_by_user_id_and_micropost_id(user.id, self.id)
  end
end
