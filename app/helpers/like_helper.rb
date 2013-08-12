module LikeHelper

  def likes_link_generator(micropost)
    if micropost.likes.count > 3
      @link_text = extract_names(micropost.likes.slice(0, 3)).join(', ') << " and #{pluralize(micropost.likes.count - 3, 'other')}"
    elsif micropost.likes.count > 1
       user_names = extract_names(micropost.likes)
      @link_text = "#{user_names[0, micropost.likes.count - 1].join(', ')} and #{user_names[micropost.likes.count - 1]}"
    end
    if micropost.likes.count > 1
      @link_text << ' like post'
    elsif micropost.likes.count == 1
      @link_text = "#{extract_names(micropost.likes).first} likes post"
    else
      @link_text = '0 likes'
    end
    @link_text
  end

  private

  def extract_names(likes)
    likes.collect { |like| like.user.name if !like.user.nil? }
  end
end
