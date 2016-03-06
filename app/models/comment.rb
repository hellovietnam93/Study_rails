class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  acts_as_tree order: "created_at DESC"
end
