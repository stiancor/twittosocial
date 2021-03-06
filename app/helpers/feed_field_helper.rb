# encoding: utf-8
module FeedFieldHelper
  def format_msg(content)
    if content.match /<|>/
      content = escape_html(content)
    end
    parse_words_one_by_one(content)
  end

  def parse_words_one_by_one(content)
    message = []
    content.split(' ').each_with_index  do |s, i|
      if absolute_link?(s)
        url_to_follow, url_to_show = extract_url(s)
        message[i] = "<a href='#{url_to_follow}' target='_blank'>#{url_to_follow}</a>#{url_to_show}"
      elsif absolute_link_without_http?(s)
        url_to_follow, url_to_show = extract_url(s)
        message[i] = "<a href='http://#{url_to_follow}' target='_blank'>#{url_to_follow}</a>#{url_to_show}"
      elsif hashtag?(s)
        tag = extract_tag(s)
        not_part_of_tag = extract_end_of_tag(s)
        search_term = get_valid_search_term(tag)
        message[i] = "<a href='/?utf8=✓&q=#{search_term}'>#{tag}</a>#{not_part_of_tag}"
      elsif username?(s)
        message[i] = "<span class='message-username'>#{s}</span>"
      else
        message[i] = s
      end
    end
    message.join(' ')
  end

  def extract_url(s)
    url_to_follow = remove_last_punction_if_it_exists(s)
    url_to_show = add_last_punction_if_it_existed(s)
    return url_to_follow, url_to_show
  end

  def absolute_link_without_http?(s)
    s.match /\Awww\.\S+\b/
  end

  def absolute_link?(s)
    s.match /\A(?:https?:\/\/)\S+\b/
  end

  def remove_last_punction_if_it_exists(str)
    str.sub(/[?.!,;]?$/, '') || str
  end

  def add_last_punction_if_it_existed(str)
    str.match(/[?.!,;]?$/) || ''
  end

  HASHTAG_REGEX = /\A#([[:alnum:]]|_)+/

  def extract_tag(s)
    s.match(HASHTAG_REGEX).to_s || s
  end

  def extract_end_of_tag(s)
    s.sub(HASHTAG_REGEX, '') || s
  end

  def hashtag?(s)
    s.match(HASHTAG_REGEX)
  end

  USERNAME_REGEX = /(\s@\w+|\A@\w+)/
  def username?(s)
    s.match(USERNAME_REGEX)
  end

  def get_valid_search_term(s)
    s.sub(/#/, '%23')
  end

  def escape_html(content)
    content.gsub!('<', '&lt;')
    content.gsub!('>', '&gt;')
    content
  end

  def rank_color_class(position)
    "place-#{position}"
  end

end