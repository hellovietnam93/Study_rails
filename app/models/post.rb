class Post < ActiveRecord::Base
  acts_as_taggable

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable

  belongs_to :user
  belongs_to :postable, polymorphic: true
  belongs_to :class_room

  validates :user_id, presence: true
  validates :class_room_id, presence: true
  validates :name, presence: true, length: {minimum: 6}
  validates :content, presence: true, length: {minimum: 6}

  ATTRIBUTES_PARAMS = [:user_id, :postable_id, :postable_type, :class_room_id,
    :name, :content, :approved, :tag_list]
end
