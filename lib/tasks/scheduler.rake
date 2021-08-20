desc "This task is called by the Heroku scheduler add-on"
task :cronstatus => :environment do
    Post.update_all ['cronstatus = ?',1]
end
# heroku run rake cronstatus --app timory
