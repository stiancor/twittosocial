require "spec_helper"

describe FeedFieldHelper do

  describe "parse micropost" do

    describe "should find http links and wrap them in <a> tags" do
      before { @micropost = parse_words_one_by_one("This micropost contains a http link. The link http://www.twittosocial.com should be transformed into a link") }
      it { @micropost.scan(/<.*?>.*?\>/)[0].should == "<a href='http://www.twittosocial.com' target='_blank'>http://www.twittosocial.com</a>" }
    end

    describe "should find https links and wrap them in <a> tags" do
      before { @micropost = parse_words_one_by_one("This micropost contains a http link. The link https://www.twittosocial.com should be transformed into a link") }
      it { @micropost.scan(/<.*?>.*?\>/)[0].should == "<a href='https://www.twittosocial.com' target='_blank'>https://www.twittosocial.com</a>" }
    end

    describe "should find all links" do
      before do @micropost = parse_words_one_by_one("First https://www.google.com second http://yahoo.com")
        @links = @micropost.scan(/<.*?>.*?\>/)
      end
      it { @links[0].should == "<a href='https://www.google.com' target='_blank'>https://www.google.com</a>" }
      it { @links[1].should == "<a href='http://yahoo.com' target='_blank'>http://yahoo.com</a>" }
    end

  end
end