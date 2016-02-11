require 'spec_helper'

describe "AuthenticationPages" do

  subject { page }

  describe "sign in page" do
    before { visit signin_path }
    it { should have_selector('h1', text: "Sign in") }
    it { should have_title( "Sign in") }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title( 'Sign in') }
      it { should have_error_message }

      describe "next page does not show error message" do
        before { click_link 'Sign in' }
        it { should_not have_error_message }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      it { should have_link("view my profile") }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Users', href: users_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by sign out" do
        before { click_link "Sign out" }
        it { should have_link("Sign in", href: signin_path) }
      end
    end
  end

  describe "authorization" do
    let(:user) { FactoryGirl.create(:user) }
    describe "for non-signed in users" do
      describe "when attempting to access a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          describe "it should render the desired protected page" do
            it { page.should have_title( 'Edit user') }
          end

          describe "when signing in again" do
            before do
              click_link "Sign out"
              click_link "Sign in"
              fill_in "Email", with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end
            it { should have_link("view my profile") }
          end
        end

      end
      describe "in the Users controller" do
        describe "visit the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title( 'Sign in') }
          it { should have_selector('div.alert.alert-notice') }
        end
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title( 'Sign in') }
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title( 'Sign in') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_title( 'Sign in') }
        end
      end
    end

    describe "in the Micropost controller" do

      describe "submitting to the create action" do
        before { post microposts_path }
        specify { response.should redirect_to(signin_path) }
      end

      describe "submitting to the destroy action" do
        before { delete micropost_path(FactoryGirl.create(:micropost)) }
        specify { response.should redirect_to(signin_path) }
      end

    end

    describe "in the Relationship controller" do
      describe "submitting to the create action" do
        before { post relationships_path }
        specify { response.should redirect_to(signin_path) }
      end

      describe "submitting to the destroy action" do
        before { delete relationship_path(1) }
        specify { response.should redirect_to(signin_path) }
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.com', name: 'Wrong user') }
      before { sign_in user }
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title( "Edit user") }
      end
      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        it { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before { sign_in non_admin }

      describe "submit to delete action" do
        before { delete user_path(user) }
        describe "should redirect to root_path" do
          it { response.should redirect_to root_path }
        end
      end

    end

  end

end
