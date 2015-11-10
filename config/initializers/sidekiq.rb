require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { :url => 'redis://redistogo:730fda790f5ac4a72ca8cab9379244aa@spadefish.redistogo.com:9284/', :size => 1 }
end

# When in Unicorn, this block needs to go in unicorn's `after_fork` callback:
Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://redistogo:730fda790f5ac4a72ca8cab9379244aa@spadefish.redistogo.com:9284/', :size => 1 }
end