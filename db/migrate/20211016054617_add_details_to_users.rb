class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_follow_approval, :integer, null: false, default: 0
    add_column :users, :is_post_time_release, :integer, null: false, default: 0
    add_column :users, :is_random_exchange_diary, :integer, null: false, default: 0
  end
end
