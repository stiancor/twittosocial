require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }

  before do
    @micropost = user.microposts.build(content: "Lorem ipsum")
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:likes) }
  it { should respond_to(:admin_message) }

  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
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
    it { should_not be_valid }
  end

  describe "with more than 250 chars" do
    before { @micropost.content = "a"*251 }
    it { should_not be_valid }
  end

end

