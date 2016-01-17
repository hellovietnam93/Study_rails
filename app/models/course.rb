class Course < ActiveRecord::Base
  has_many :class_rooms, dependent: :destroy

  extend FriendlyId
  friendly_id :uid, use: [:slugged, :finders]
end
