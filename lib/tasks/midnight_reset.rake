
namespace :midnight_reset do
    desc "定期的に日記を公開"
      task :reset_flag => :environment do
      #ログ
      logger = Logger.new 'log/midnight_reset.log'

      #ここから処理を書いていく
      # Post.update_all ['cronstatus = ?',1]
      User.update_all ['today_comments_count = ?',0]
      #デバッグのため
      p "ここまでOK"
    end

    desc "二つ目のタスクを追加"
    task :test_flag => :environment do
      p "テストフラグ"
    end

end

# rails -tでタスク一覧を確認 descも見える(メモ)
# rails タスク名 (rails reset_flag)で実行
