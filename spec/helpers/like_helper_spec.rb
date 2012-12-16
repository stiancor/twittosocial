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
      it { likes_link_generator(@micropost).should == "0 likes" }
    end

    describe "Micropost has one like" do
      before do
        @micropost = user.microposts.build(content: "Some message")
        @micropost.save
        @micropost.like!(user)
      end
      it { likes_link_generator(@micropost).should =~ /Person \d+? likes post/ }
    end

    describe "Micropost has two likes" do
      before do
        @micropost = user.microposts.build(content: "Some message")
        @micropost.save
        @micropost.like!(user)
        @micropost.like!(user2)
      end
      it { likes_link_generator(@micropost).should =~ /Person \d+? and Person \d+? like post/ }
    end

    describe "Micropost has three likes" do
      before do
        @micropost = user.microposts.build(content: "Some message")
        @micropost.save
        @micropost.like!(user)
        @micropost.like!(user2)
        @micropost.like!(user3)
      end
      it { likes_link_generator(@micropost).should =~ /Person \d+?, Person \d+? and Person \d+? like post/ }
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
      it { likes_link_generator(@micropost).should =~ /Person \d+?, Person \d+?, Person \d+? and 1 other like post/ }
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
      it { likes_link_generator(@micropost).should =~ /Person \d+?, Person \d+?, Person \d+? and 2 others like post/ }
    end
  end

end