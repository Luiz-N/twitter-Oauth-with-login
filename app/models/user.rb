class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :tweets

  def fetch_tweets(user)
    @tweets = user.user_timeline(self.username)
    @tweets.each do |tweet|
      # p tweet[:attrs].keys
      id_int = tweet[:attrs][:id]
      content = tweet[:attrs][:text]
      t_created_at = tweet[:attrs][:created_at]

      unless self.tweets.map{|tweet| tweet.id_int }.include?(id_int)
        self.tweets << Tweet.create(:content => content, :id_int => id_int, :t_created_at => t_created_at)
      end
    end
    self.tweets
  end

  def stale?
    p Time.new - (60*60*24)
    self.tweets.nil? ||  self.tweets.order('created_at DESC')[0].created_at < Time.new - (60)
  end
end

