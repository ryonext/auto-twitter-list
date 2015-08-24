class UpdatingListWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false

  recurrence backfill: true do
    hourly.minute_of_hour(0, 20, 40)
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
