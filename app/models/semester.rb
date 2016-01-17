class Semester < ActiveRecord::Base
  has_many :class_rooms, dependent: :destroy

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  validates :name, presence: true, length: {maximum: 8}
end
