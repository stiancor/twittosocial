class Event < ActiveRecord::Base
  attr_accessible :title, :location, :start_time, :end_time, :invitation

  belongs_to :user

  validates :title, presence: true, length: {maximum: 250}
  validates_presence_of :start_time, :end_time
  validates :invitation, presence: true, length: {maximum: 3000}
  validates :user_id, presence: true
end
