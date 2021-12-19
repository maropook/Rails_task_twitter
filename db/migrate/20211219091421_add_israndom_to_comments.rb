class AddIsrandomToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :is_random_dialy, :integer, null: false, default: 0
  end
end
