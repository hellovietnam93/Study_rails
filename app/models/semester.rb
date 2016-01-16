class Semester < ActiveRecord::Base
  has_many :class_rooms, dependent: :destroy

  extend FriendlyId
  friendly_id :name, use: :slugged
end
