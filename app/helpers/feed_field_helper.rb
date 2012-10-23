module FeedFieldHelper
  def format_msg(content)
    if !content.match /<|>/
      create_links_if_present(content)
    else
      escape_html(content)
    end
  end

  def create_links_if_present(content)
    i = 0
    returnArray = []
    content.split(' ').each do |s|
      if s.match /http:\/\/.*?/
        returnArray[i] = "<a href='#{s}' target='_blank'>#{s}</a>"
      else
        returnArray[i] = s
      end
      i += 1
    end
    returnArray.join(' ')
  end

  def escape_html(content)
    content.gsub!('<', '&lt;')
    content.gsub!('>', '&gt;')
  end
end