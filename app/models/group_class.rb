class GroupClass < ActiveRecord::Base
  belongs_to :class_room
  belongs_to :user
end
