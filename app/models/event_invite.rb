class EventInvite < ActiveRecord::Base

  attr_accessible :attend_status

  belongs_to :event
  belongs_to :user
  validates :attend_status, presence: true
  validates :user_id, presence: true
  validates :event_id, presence: true

end
