class GroupClass < ActiveRecord::Base
  belongs_to :class_room
  belongs_to :user

  extend FriendlyId
  friendly_id :name, [:slugged, :finders]
end
