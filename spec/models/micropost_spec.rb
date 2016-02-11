require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }

  before do
    @micropost = user.microposts.build(content: "Lorem ipsum")
  end

  subject { @micropost }

  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:likes) }
  it { is_expected.to respond_to(:admin_message) }

  describe '#user' do
    subject { super().user }
    it { is_expected.to eq(user) }
  end

  it { is_expected.to be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { is_expected.not_to be_valid }
  end

  describe "with more than 250 chars" do
    before { @micropost.content = "a"*251 }
    it { is_expected.not_to be_valid }
  end

end

