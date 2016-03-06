class Forum < ActiveRecord::Base
  has_many :posts, dependent: :destroy

  belongs_to :class_room
end
