class AddCommentslimitUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :today_comments_count, :integer, null: false, default: 0
    add_column :users, :comments_count_limit, :integer, null: false, default: 5
  end
end
