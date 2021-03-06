class UserClass < ActiveRecord::Base
  attr_accessor :key
  belongs_to :user
  belongs_to :class_room

  enum status: [:waiting, :take_in]
end
