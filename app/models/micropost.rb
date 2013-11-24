class Micropost < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessible :content, :admin_message, :header_message
  belongs_to :user
  has_many :likes
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 250}

  attr_accessor :header_message

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

  def self.search(params)
    tire.search(load: true, page: (params[:page] || 1), per_page: 30) do
      query { string params[:q]} if params[:q].present?
      sort { by :created_at, 'desc' }
    end
  end
end
