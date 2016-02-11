require 'spec_helper'

describe "EventPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  describe "not signed in" do
    before { visit events_path }
    it { is_expected.to have_link("Sign in", href: signin_path) }
  end

  describe "with signed in user" do
    before { sign_in user }

    describe "Should get list of event" do
      before { visit events_path }
      it do
        is_expected.to have_selector('h1', text: 'All upcoming events')
        is_expected.to have_selector('h3', text: 'Sorry, no events planned :-/')
        is_expected.to have_link 'Create new event'
      end
    end
  end

end