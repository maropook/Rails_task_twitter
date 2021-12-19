desc "This task is called by the Heroku scheduler add-on"
task :cronstatus => :environment do
    Post.update_all ['cronstatus = ?',1]
end

task :comments => :environment do
    User.update_all ['today_comments_count = ?',0]
end
# heroku run rake cronstatus --app timory
