class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :likes
  has_many :liked_users, through: :likes, source: :user

  mount_uploader :image, ImageUploader

  enum status:{nonreleased: 0, released: 1}
end

# Post.update_all ['cronstatus = ?',1]