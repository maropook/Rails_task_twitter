class ChangeIsReadlimitDefaultOnUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :readlimit, from: 12, to: 23
  end
end
