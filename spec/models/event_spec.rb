require 'spec_helper'

describe Event do
  let(:user) { FactoryGirl.create(:user) }

  before do
    @event = FactoryGirl.create(:event)
  end

  subject { @event }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:location) }
  it { is_expected.to respond_to(:start_time) }
  it { is_expected.to respond_to(:end_time) }
  it { is_expected.to respond_to(:invitation) }

  it { is_expected.to be_valid }

  describe 'when user_id is not present' do
    before { @event.user_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'when title is not present' do
    before { @event.title = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'when title is blank' do
    before { @event.title = ' ' }
    it { is_expected.not_to be_valid }
  end

  describe 'when title is too long' do
    before { @event.title = 'a'*251 }
    it { is_expected.not_to be_valid }
  end

  describe 'when start_time is not present' do
    before { @event.start_time = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'when end_time is not present' do
    before { @event.end_time = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'when invitation is nil' do
    before { @event.invitation = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'when invitation is blank' do
    before { @event.invitation = ' ' }
    it { is_expected.not_to be_valid }
  end

  describe 'when invitation is too long' do
    before { @event.invitation = 'a'*3001 }
    it { is_expected.not_to be_valid }
  end

  describe 'start_time cannot be after end_time' do
    before do
      @event.start_time = DateTime.new.end_of_day
      @event.end_time = DateTime.new.at_beginning_of_day
    end
    it { is_expected.not_to be_valid }
  end

end
