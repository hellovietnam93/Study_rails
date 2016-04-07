class Team < ActiveRecord::Base
  belongs_to :class_room

  has_many :class_teams, dependent: :destroy
  has_many :users, through: :class_teams

  ATTRIBUTES_PARAMS = [:name, :class_room_id, user_ids: []]

  validates :name, presence: true
end