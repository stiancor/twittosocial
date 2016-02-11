# encoding: utf-8
require "spec_helper"

describe FeedFieldHelper do

  describe "parse micropost" do

    describe "should find http links and wrap them in <a> tags" do
      before { @micropost = parse_words_one_by_one("This micropost contains a http link. The link http://www.twittosocial.com should be transformed into a link") }
      it { expect(@micropost.scan(/<.*?>.*?\>/)[0]).to eq("<a href='http://www.twittosocial.com' target='_blank'>http://www.twittosocial.com</a>") }
    end

    describe "should find https links and wrap them in <a> tags" do
      before { @micropost = parse_words_one_by_one("This micropost contains a http link. The link https://www.twittosocial.com should be transformed into a link") }
      it { expect(@micropost.scan(/<.*?>.*?\>/)[0]).to eq("<a href='https://www.twittosocial.com' target='_blank'>https://www.twittosocial.com</a>") }
    end

    describe "should find both links" do
      before do
        @micropost = parse_words_one_by_one("First https://www.google.com second http://yahoo.com")
        @links = @micropost.scan(/<.*?>.*?\>/)
      end
      it { expect(@links[0]).to eq("<a href='https://www.google.com' target='_blank'>https://www.google.com</a>") }
      it { expect(@links[1]).to eq("<a href='http://yahoo.com' target='_blank'>http://yahoo.com</a>") }
    end

    describe "links without http" do
      describe "link starting with www should be wrapped with <a> tags" do
        before { @micropost = parse_words_one_by_one("This is a www.twittosocial.com link") }
        it { expect(@micropost.scan(/<.*?>.*?\>/)[0]).to eq("<a href='http://www.twittosocial.com' target='_blank'>www.twittosocial.com</a>") }
      end
    end

    describe "links with and without http prefix" do
      describe "should be wrapped with <a> tags" do
        before do
          @micropost = parse_words_one_by_one("This is a www.twittosocial.com link and this http://www.twittosocial.com that has http in it")
          @links = @micropost.scan(/<.*?>.*?\>/)
        end
        it { expect(@links[0]).to eq("<a href='http://www.twittosocial.com' target='_blank'>www.twittosocial.com</a>") }
        it { expect(@links[1]).to eq("<a href='http://www.twittosocial.com' target='_blank'>http://www.twittosocial.com</a>") }
      end
    end

    describe "escape tags in message" do
      before { @micropost = escape_html("This <script>alert('Twittosocial rocks');</script>") }
      it { expect(@micropost).to eq("This &lt;script&gt;alert('Twittosocial rocks');&lt;/script&gt;") }
    end

    describe "create hashtag link" do
      before { @micropost = parse_words_one_by_one("This url has one #hashtag in it") }
      it { expect(@micropost).to eq("This url has one <a href='/?utf8=✓&q=%23hashtag'>#hashtag</a> in it") }
    end

    describe "create hashtag link with special chars" do
      before { @micropost = parse_words_one_by_one("This url has one #hashtægs and #æøå") }
      it { expect(@micropost).to eq("This url has one <a href='/?utf8=✓&q=%23hashtægs'>#hashtægs</a> and <a href='/?utf8=✓&q=%23æøå'>#æøå</a>") }
    end

    describe "create hashtag link at the end of message" do
      before { @micropost = parse_words_one_by_one("yumyum,ikke noe særlig bra start på dagen det der! hos oss tror jeg det må være et tidshull eller noe, skjønner i hvertfall ikke hvordan et er mulig å stå opp kl 0600 og likevel ikke være på jobb før kl 0900..#faaraldrinoktimerhjemmeellerpaajobb") }
      it { expect(@micropost).to eq("yumyum,ikke noe særlig bra start på dagen det der! hos oss tror jeg det må være et tidshull eller noe, skjønner i hvertfall ikke hvordan et er mulig å stå opp kl 0600 og likevel ikke være på jobb før kl 0900..#faaraldrinoktimerhjemmeellerpaajobb") }
    end

    describe "create hashtag in message" do
      before { @micropost = parse_words_one_by_one("Passer bra at vi utsetter #dinner @anhtr. Tilbake fra Barcelona nå. Kan informere at > 20 C føles like deilig i år som i fjor!") }
      it { expect(@micropost).to eq("Passer bra at vi utsetter <a href='/?utf8=✓&q=%23dinner'>#dinner</a> <span class='message-username'>@anhtr.</span> Tilbake fra Barcelona nå. Kan informere at > 20 C føles like deilig i år som i fjor!") }
    end

    describe "create hashtag with underscore" do
      before { @micropost = parse_words_one_by_one("Hele denne #hashtag_med_underscore skal linkes ") }
      it { expect(@micropost).to eq("Hele denne <a href='/?utf8=✓&q=%23hashtag_med_underscore'>#hashtag_med_underscore</a> skal linkes") }
    end

    describe "username should have span with class" do
      before { @micropost = parse_words_one_by_one("Dette er en melding til deg @alibaba. Testing 123") }
      it { expect(@micropost).to eq("Dette er en melding til deg <span class='message-username'>@alibaba.</span> Testing 123") }
    end

  end
end