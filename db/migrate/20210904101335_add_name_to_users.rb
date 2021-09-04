class AddNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :readtime, :integer,default: 12
    add_column :users, :readlimit, :integer,default: 12
  end
end
