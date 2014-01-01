require 'spec_helper'

describe EventInvite do
  let(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:event) }

  before do
    @event_invite = FactoryGirl.create(:event_invite)
  end

  subject { @event_invite }

  it { should respond_to(:attend_status) }
  it { should respond_to(:user) }
  it { should respond_to(:event) }

  it { should be_valid }

  describe 'when user_id is not present' do
    before { @event_invite.user_id = nil }
    it { should_not be_valid }
  end

  describe 'when event_id is not present' do
    before { @event_invite.event_id = nil }
    it { should_not be_valid }
  end

  describe 'when attend_status is not present' do
    before { @event_invite.attend_status = nil }
    it { should_not be_valid }
  end

  describe 'when attend_status has invalid option' do
    before { @event_invite.attend_status = 'something' }
    it { should_not be_valid }
  end

end
