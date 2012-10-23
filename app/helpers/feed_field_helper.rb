module FeedFieldHelper
  def format_msg(content)
    i = 0
    returnArray = []
    content.split(' ').each do |s|
      if s.match /http:\/\/.*?/
        returnArray[i] = "<a href='#{s}'>#{s}</a>"
      else
        returnArray[i] = s
      end
      i += 1
    end
    returnArray.join(' ')
  end
end