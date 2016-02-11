require 'spec_helper'

describe Like do

  let(:micropost) { FactoryGirl.create(:micropost) }

  before do
    @like = micropost.likes.build(micropost_id: micropost.id)
    @like.user_id = micropost.user.id
  end

  subject { @like }

  it { is_expected.to respond_to(:micropost_id) }

  it { is_expected.to be_valid }

  describe "when user does not exist" do
    before { @like.user_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when micropost does not exist" do
    before { @like.micropost_id = nil }
    it { is_expected.not_to be_valid }
  end

end
