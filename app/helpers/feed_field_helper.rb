module FeedFieldHelper
  def format_msg(content)
    if !content.match /<|>/
      parse_words_one_by_one(content)
    else
      escape_html(content)
    end
  end

  def parse_words_one_by_one(content)
    i = 0
    returnArray = []
    content.split(' ').each do |s|
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
      i += 1
    end
    returnArray.join(' ')
  end

  def remove_last_punction_if_it_exists(str)
    newStr = str.sub(/[?.!,;]?$/, '') || str
    newStr
  end

  def add_last_punction_if_it_existed(str)
    punction = str.match(/[?.!,;]?$/) || ''
    punction
  end

  def escape_html(content)
    content.gsub!('<', '&lt;')
    content.gsub!('>', '&gt;')
    content
  end
end