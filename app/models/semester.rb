class Semester < ActiveRecord::Base
  has_many :class_rooms, dependent: :destroy

  validates :name, presence: true, length: {maximum: 8}
end
