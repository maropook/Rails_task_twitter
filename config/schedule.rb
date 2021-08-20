set :output, 'log/crontab.log'
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
# require File.expand_path(File.dirname(__FILE__) + "/environment")
# set :output, 'log/cron.log'

every 1.minute do
  rake "midnight_reset:reset_flag"
end

# logの確認
# cat log/crontab.log

# cronにデータを反映
# bundle exec whenever --update-crontab

# cronにデータを削除
# bundle exec whenever --update-crontab
