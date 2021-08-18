set :output, 'log/crontab.log'
set :environment,"development"
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