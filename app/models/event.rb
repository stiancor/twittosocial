class Event < ActiveRecord::Base
  attr_accessible :title, :location, :start_time, :end_time, :invitation, :send_mail

  belongs_to :user
  has_many :event_invites, dependent: :destroy

  validates :title, presence: true, length: {maximum: 250}
  validates_presence_of :start_time, :end_time
  validates :invitation, presence: true, length: {maximum: 3000}
  validates :user_id, presence: true
  validate :start_time_before_end_time

  private

  def start_time_before_end_time
    if start_time && end_time && start_time > end_time
      errors.add(:start_time, 'Start time must be before end time')
    end
  end
end
