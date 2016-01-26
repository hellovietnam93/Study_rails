class OnlineTest < ActiveRecord::Base
  belongs_to :user
  belongs_to :class_room
  belongs_to :question

  has_many :results, dependent: :destroy
end
