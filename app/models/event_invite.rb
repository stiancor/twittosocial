class EventInvite < ActiveRecord::Base

  STATUS_OPTIONS = %w(no_reply yes no maybe)
  attr_accessible :attend_status

  belongs_to :event
  belongs_to :user
  validates :attend_status, presence: true, :inclusion => {in: STATUS_OPTIONS}
  validates :user_id, presence: true
  validates :event_id, presence: true

end
