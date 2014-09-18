require 'spec_helper'

describe ApplicationHelper do
  describe "full title" do
    it "should include the page title" do
      full_title('foo').should =~ /foo/
    end

    it "should include the base title" do
      full_title('foo').should =~ /^TwittoSocial/
    end

    it "should not include a bar on the home page when empty string" do
      full_title('').should_not =~ /\|/
    end

  end
end