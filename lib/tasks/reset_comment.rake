namespace :reset_comment do
    desc "comment_countを0に"
    task :reset  => :environment do
    #ログ
    #ここから処理を書いていく
    p "OK"

    # Post.update_all ['cronstatus = ?',1]
    User.update_all ['today_comments_count = ?',0]
    #デバッグのため
    end

end
