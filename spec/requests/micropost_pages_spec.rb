require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    it "invalid information" do
      expect { click_button "Post" }.not_to change(Micropost, :count)
    end

    describe "error message" do
      before { click_button "Post" }
      it { is_expected.to have_content('error') }
    end
  end

  describe "microposts destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    describe "as correct user" do
      before { visit root_path }
      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

end
