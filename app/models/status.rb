require 'twitter_session'

class Status < ActiveRecord::Base

  validate :body, :presence => true, length: {maximum: 140}
  validate :twitter_status_id, :presence => true, :uniqueness => true
  validate :twitter_user_id, :presence => true

  def self.fetch_by_user_id!(twitter_user_id)
    path = "statuses/user_timeline"
    query_values = {
      :user_id => twitter_user_id.to_s
    }
    tweets = TwitterSession.get(path, query_values)

    # Save each tweets into the database
    tweets.each do |tweet|
      status = Status.new
      status.body = tweet['text']
      status.twitter_status_id = tweet['id_str']
      status.twitter_user_id = tweet['user']['id_str']
      status.save!
    end
  end



end
