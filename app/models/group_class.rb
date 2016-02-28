class GroupClass < ActiveRecord::Base
  belongs_to :class_room
  belongs_to :user
  belongs_to :forum
end
