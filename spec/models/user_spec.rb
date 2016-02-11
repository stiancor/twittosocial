require 'spec_helper'

describe User do
  before {
    @user = User.new(name: 'Example user', email: 'example@example.com', username: 'example', password: 'foobar', password_confirmation: 'foobar')
  }

  subject { @user }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password_digest) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:remember_token) }
  it { is_expected.to respond_to(:admin) }
  it { is_expected.to respond_to(:authenticate) }
  it { is_expected.to respond_to(:microposts) }
  it { is_expected.to respond_to(:feed) }
  it { is_expected.to respond_to(:relationships) }
  it { is_expected.to respond_to(:followed_users) }
  it { is_expected.to respond_to(:reverse_relationships) }
  it { is_expected.to respond_to(:followers) }
  it { is_expected.to respond_to(:following?) }
  it { is_expected.to respond_to(:follow!) }
  it { is_expected.to respond_to(:unfollow!) }

  it { is_expected.to be_valid }
  it { is_expected.not_to be_admin }

  describe "accessible attributes" do
    it "should not allow access to admin" do
      expect do
        User.new(admin: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@foo+bar.com foo@foo_bar.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM example.user@foo.no a+b@baz.zn]
      addresses.each do |address|
        @user.email = address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { is_expected.not_to be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = "" }
    it { is_expected.not_to be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "notSame" }
    it { is_expected.not_to be_valid }
  end

  describe "when password_confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a"*5 }
    it { is_expected.not_to be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { is_expected.to eq(found_user.authenticate(@user.password)) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { is_expected.not_to eq(user_for_invalid_password) }
      specify "should " do
        expect(user_for_invalid_password).to be_falsey
      end
    end
  end

  describe "remember token" do
    before { @user.save }

    describe '#remember_token' do
      subject { super().remember_token }
      it { is_expected.not_to be_blank }
    end
  end

  describe "micropost association" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end
    it "should have the right microposts in the right order" do
      expect(@user.microposts).to eq([newer_micropost, older_micropost])
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |m|
        expect(Micropost.find_by_id(m.id)).to be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      describe '#feed' do
        subject { super().feed }
        it { is_expected.to include(older_micropost) }
      end

      describe '#feed' do
        subject { super().feed }
        it { is_expected.to include(newer_micropost) }
      end

      describe '#feed' do
        subject { super().feed }
        it { is_expected.not_to include(unfollowed_post) }
      end

      describe '#feed' do
        subject { super().feed }
        it do
        followed_user.microposts.each do |micropost|
          is_expected.to include(micropost)
        end
      end
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end
    it { is_expected.to be_following(other_user) }

    describe '#followed_users' do
      subject { super().followed_users }
      it { is_expected.to include(other_user) }
    end

    describe "followed user" do
      subject { other_user }

      describe '#followers' do
        subject { super().followers }
        it { is_expected.to include(@user) }
      end
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { is_expected.not_to be_following(other_user) }

      describe '#followed_users' do
        subject { super().followed_users }
        it { is_expected.not_to include(other_user) }
      end
    end
  end

end



