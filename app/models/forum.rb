class Forum < ActiveRecord::Base
  has_many :posts, dependent: :destroy, as: :postable

  belongs_to :class_room
end
