module StaticPagesHelper
  def calculate_user_rank
    micropost_rank = Micropost.unscoped.select('user_id, count(id) micropost_count').where('created_at > ?', Date.today.advance(days: -30)).group('user_id').to_a
    event_rank = Event.select('user_id, count(id) event_count').where('start_time between ? and ?', Date.today.advance(days: -14), Date.today.advance(days: 30)).group('user_id').to_a
    event_comment_rank = EventComment.unscoped.select('user_id, count(id) event_comment_count').where('created_at > ?', Date.today.advance(days: -30)).group('user_id').to_a
    like_rank = Micropost.unscoped.select('microposts.user_id micropost_user_id, likes.user_id like_user_id').joins(:likes).where('microposts.created_at > ?', Date.today.advance(days: -30)).to_a
    create_rank_map(micropost_rank, event_rank, event_comment_rank, like_rank)
  end
end
