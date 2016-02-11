require 'spec_helper'

describe EventInvite do
  let(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.create(:event) }

  before do
    @event_invite = FactoryGirl.create(:event_invite)
  end

  subject { @event_invite }

  it { is_expected.to respond_to(:attend_status) }
  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:event) }

  it { is_expected.to be_valid }

  describe 'when user_id is not present' do
    before { @event_invite.user_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'when event_id is not present' do
    before { @event_invite.event_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'when attend_status is not present' do
    before { @event_invite.attend_status = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'when attend_status has invalid option' do
    before { @event_invite.attend_status = 'something' }
    it { is_expected.not_to be_valid }
  end

end
