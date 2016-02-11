require "spec_helper"

describe LikeHelper do

  describe "Likes link generator" do

    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }
    let(:user4) { FactoryGirl.create(:user) }
    let(:user5) { FactoryGirl.create(:user) }

    describe "Micropost has no likes" do
      before { @micropost = Micropost.new(content: "Some message") }
      it { expect(likes_link_generator(@micropost)).to eq("0 likes") }
    end

    describe "Micropost has one like" do
      before do
        @micropost = user.microposts.build(content: "Some message")
        @micropost.save
        @micropost.like!(user)
      end
      it { expect(likes_link_generator(@micropost)).to match(/Person \d+? likes post/) }
    end

    describe "Micropost has two likes" do
      before do
        @micropost = user.microposts.build(content: "Some message")
        @micropost.save
        @micropost.like!(user)
        @micropost.like!(user2)
      end
      it { expect(likes_link_generator(@micropost)).to match(/Person \d+? and Person \d+? like post/) }
    end

    describe "Micropost has three likes" do
      before do
        @micropost = user.microposts.build(content: "Some message")
        @micropost.save
        @micropost.like!(user)
        @micropost.like!(user2)
        @micropost.like!(user3)
      end
      it { expect(likes_link_generator(@micropost)).to match(/Person \d+?, Person \d+? and Person \d+? like post/) }
    end

    describe "Micropost has four likes" do
      before do
        @micropost = user.microposts.build(content: "Some message")
        @micropost.save
        @micropost.like!(user)
        @micropost.like!(user2)
        @micropost.like!(user3)
        @micropost.like!(user4)
      end
      it { expect(likes_link_generator(@micropost)).to match(/Person \d+?, Person \d+?, Person \d+? and 1 other like post/) }
    end

    describe "Micropost has five likes" do
      before do
        @micropost = user.microposts.build(content: "Some message")
        @micropost.save
        @micropost.like!(user)
        @micropost.like!(user2)
        @micropost.like!(user3)
        @micropost.like!(user4)
        @micropost.like!(user5)
      end
      it { expect(likes_link_generator(@micropost)).to match(/Person \d+?, Person \d+?, Person \d+? and 2 others like post/) }
    end
  end

end