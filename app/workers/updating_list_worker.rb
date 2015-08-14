class UpdatingListWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence backfill: true do
    hourly
  end

  def perform(*args)
    # Twitterから最新のリストを取る
    client = TwitterClient.new(
      consumer_key:        ENV['CONSUMER_KEY'],
      consumer_secret:     ENV['CONSUMER_SECRET'],
      access_token:        ENV['ACCESS_TOKEN'],
      access_token_secret: ENV['ACCESS_TOKEN_SECRET'],
    )
    client.update_list!
  end
end
