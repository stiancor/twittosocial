class EventComment < ActiveRecord::Base

  attr_accessible :event_id, :user, :content
  belongs_to :event
  belongs_to :user

  validates :content, presence: true, length: {maximum: 250}

  default_scope order: 'event_comments.created_at DESC'

end
