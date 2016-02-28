class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum
  belongs_to :class_room
end
