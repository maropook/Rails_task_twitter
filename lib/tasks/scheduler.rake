desc "This task is called by the Heroku scheduler add-on"
task :cronstatus => :development do
    Post.update_all ['cronstatus = ?',1]
end
