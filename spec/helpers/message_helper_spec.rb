# encoding: utf-8
require 'spec_helper'

describe MessageHelper do

  let(:user) { FactoryGirl.create(:user) }

  before do
    User.create!(name: 'Example user',
                 email: 'example@example.com',
                 username: 'someuser',
                 password: 'foobar',
                 password_confirmation: 'foobar')
  end

  describe 'only matches if username exists' do
    it { expect(get_emails(['someuser', 'nouser']).length).to eq(1) }
  end

  describe 'extract usernames from micropost' do
    before { @user_names = find_users_to_email('@stiancor, this is true, but @somebody, meaning @nobody does not agree! @') }
    it { expect(@user_names.length).to eq(3) }
    it { expect(@user_names[0]).to eq('stiancor') }
    it { expect(@user_names[1]).to eq('somebody') }
    it { expect(@user_names[2]).to eq('nobody') }
  end

  describe 'no usernames in string without usernames' do
    it { expect(find_users_to_email('This string contains no usernames @, that is for sure').length).to eq(0) }
  end

  describe 'micropost with three usernames' do
    it { expect(find_users_to_email('Vi planlegger julebordet og er usikker på om @benty @chaub og @marie liker pinnekjøtt... Yes or no').length).to eq(3) }
  end

end