require "spec_helper"

describe MicropostHelper do

  let(:user) { FactoryGirl.create(:user) }

  before do
    User.create!(name: "Example user",
                 email: "example@example.com",
                 username: "someuser",
                 password: "foobar",
                 password_confirmation: "foobar")
  end

  describe "only matches if username exists" do
    it { get_emails(['someuser', 'nouser']).length.should == 1}
  end

  describe "extract usernames from micropost" do
    before {@user_names = extract_user_names("@stiancor, this is true, but @somebody, meaning @nobody does not agree! @")}
    it { @user_names.length.should == 3}
    it { @user_names[0].should == "stiancor"}
    it { @user_names[1].should == "somebody"}
    it { @user_names[2].should == "nobody"}
  end

  describe "no usernames in string without usernames" do
    it { extract_user_names("This string contains no usernames @, that is for sure").length.should == 0}
  end
end