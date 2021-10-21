class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user,dependent: :destroy

  mount_uploader :image, ImageUploader

  enum status:{nonreleased: 0, released: 1}

  def self.search(keyword)
    where(["content like?","%#{keyword}%"])
  end

  def self.searchfollow(keyword)
    where(["content like?","%#{keyword}%"])
  end


end

# Post.update_all ['cronstatus = ?',1]
