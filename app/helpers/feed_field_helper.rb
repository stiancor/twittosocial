module FeedFieldHelper
  def format_msg(content)
    if !content.match /<|>/
      parse_words_one_by_one(content)
    else
      escape_html(content)
    end
  end

  def parse_words_one_by_one(content)
    returnArray = []
    content.split(' ').each_with_index  do |s, i|
      if s.match /\A(?:https?:\/\/)\S+\b/
        url = remove_last_punction_if_it_exists(s)
        punction = add_last_punction_if_it_existed(s)
        returnArray[i] = "<a href='#{url}' target='_blank'>#{url}</a>#{punction}"
      elsif s.match /\Awww\.\S+\b/
        url = remove_last_punction_if_it_exists(s)
        punction = add_last_punction_if_it_existed(s)
        returnArray[i] = "<a href='http://#{url}' target='_blank'>#{url}</a>#{punction}"
      else
        returnArray[i] = s
      end
    end
    returnArray.join(' ')
  end

  def remove_last_punction_if_it_exists(str)
    str.sub(/[?.!,;]?$/, '') || str
  end

  def add_last_punction_if_it_existed(str)
    str.match(/[?.!,;]?$/) || ''
  end

  def escape_html(content)
    content.gsub!('<', '&lt;')
    content.gsub!('>', '&gt;')
    content
  end
end