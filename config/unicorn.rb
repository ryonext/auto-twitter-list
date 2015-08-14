# config/unicorn.rb
timeout 15
preload_app true

worker_processes 3

# whatever you had in your unicorn.rb file
@sidekiq_pid = nil

run_sidekiq_in_this_thread = ENV["RACK_ENV"]=="development" ? false : true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  if run_sidekiq_in_this_thread # Sidekiq関連はここ！
    @resque_pid ||= spawn("bundle exec sidekiq -c 2")
    Rails.logger.info('Spawned sidekiq #{@request_pid}')
  end
end


after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
