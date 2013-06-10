require 'spec_helper'

describe Event do
  let(:user) { FactoryGirl.create(:user) }

  before do
    @event = FactoryGirl.create(:event)
  end

  subject { @event }

  it { should respond_to(:title) }
  it { should respond_to(:location) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:invitation) }

  describe 'accessible attributes' do
    it 'should not have access to user' do
      expect do
        Event.new(user_id: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  it { should be_valid }

  describe 'when user_id is not present' do
    before { @event.user_id = nil }
    it { should_not be_valid }
  end

  describe 'when title is not present' do
    before { @event.title = nil }
    it { should_not be_valid }
  end

  describe 'when title is blank' do
    before { @event.title = ' ' }
    it { should_not be_valid }
  end

  describe 'when title is too long' do
    before { @event.title = 'a'*251 }
    it { should_not be_valid }
  end

  describe 'when start_time is not present' do
    before { @event.start_time = nil }
    it { should_not be_valid }
  end

  describe 'when end_time is not present' do
    before { @event.end_time = nil }
    it { should_not be_valid }
  end

  describe 'when invitation is nil' do
    before { @event.invitation = nil }
    it { should_not be_valid }
  end

  describe 'when invitation is blank' do
    before { @event.invitation = ' ' }
    it { should_not be_valid }
  end

  describe 'when invitation is too long' do
    before { @event.invitation = 'a'*3001 }
    it { should_not be_valid }
  end

  describe 'start_time cannot be after end_time' do
    before do
      @event.start_time = DateTime.new.end_of_day
      @event.end_time = DateTime.new.at_beginning_of_day
    end
    it { should_not be_valid }
  end

end
