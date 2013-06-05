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

end
