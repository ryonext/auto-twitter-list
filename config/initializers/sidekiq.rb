Sidekiq.configure_server do |config|
  if Rails.env.production?
    if ENV['REDISTOGO_URL']
      config.redis = { url: ENV['REDISTOGO_URL'], namespace: 'sidekiq' }
    end
  else
    config.redis = { url: 'redis://localhost:6379', namespace: 'sidekiq' }
  end
end
