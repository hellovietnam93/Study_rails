class Comment < ActiveRecord::Base
  has_many :likes, as: :likeable

  belongs_to :user
  belongs_to :post

  acts_as_tree order: "created_at DESC"

  validates :user_id, presence: true

  ATTRIBUTES_PARAMS = [:user_id, :post_id, :content, :parent_id]
end
