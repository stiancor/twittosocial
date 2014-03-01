module LikeHelper

  def likes_link_generator(micropost)
    if micropost.likes.length > 3
      @link_text = extract_names(micropost.likes.slice(0, 3)).join(', ') << " and #{pluralize(micropost.likes.length - 3, 'other')}"
    elsif micropost.likes.length > 1
       user_names = extract_names(micropost.likes)
      @link_text = "#{user_names[0, micropost.likes.length - 1].join(', ')} and #{user_names[micropost.likes.length - 1]}"
    end
    if micropost.likes.length > 1
      @link_text << ' like post'
    elsif micropost.likes.length == 1
      @link_text = "#{extract_names(micropost.likes).first} likes post"
    else
      @link_text = '0 likes'
    end
    @link_text
  end

  private

  def extract_names(likes)
    likes.collect { |like| like.user.name unless like.user.nil? }
  end
end
