web: bundle exec unicorn_rails -p $PORT -c ./config/unicorn.rb

worker: bundle exec sidekiq -q notify, 5 -q default -e production -C config/sidekiq.yml
