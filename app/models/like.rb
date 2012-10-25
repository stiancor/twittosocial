class Like < ActiveRecord::Base
  attr_accessible :micropost_id

  belongs_to :micropost, class_name: "Micropost"

  validates :micropost_id, presence: true
  validates :user_id, presence: true
end
