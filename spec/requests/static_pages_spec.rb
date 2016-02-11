require 'spec_helper'

describe "Static pages" do

  subject {
    page
  }

  describe "Home page" do
    before {
      visit root_path
    }
    it { is_expected.to have_title(full_title('')) }
    it { is_expected.not_to have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { is_expected.to have_link("0 following", href: following_user_path(user)) }
        it { is_expected.to have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before {
      visit help_path
    }
    it { is_expected.to have_selector('h1', text: 'Help') }
    it { is_expected.to have_title(full_title('Help')) }
  end

  describe "About page" do
    before {
      visit about_path
    }
    it { is_expected.to have_selector('h1', text: 'About Us') }
    it { is_expected.to have_title(full_title('About Us')) }
  end

  describe "Contact page" do
    before {
      visit contact_path
    }
    it { is_expected.to have_selector('h1', text: 'Contact') }
    it { is_expected.to have_title(full_title('Contact')) }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Sign in"
    expect(page).to have_title(full_title('Sign in'))
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "twittosocial"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))

  end
end
