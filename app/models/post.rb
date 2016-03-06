class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum
  belongs_to :class_room

  validates :user_id, presence: true
  validates :forum_id, presence: true
  validates :class_room_id, presence: true
  validates :name, presence: true, length: {minimum: 6}
  validates :content, presence: true, length: {minimum: 6}

  ATTRIBUTES_PARAMS = [:user_id, :forum_id, :class_room_id, :name, :content]
end
