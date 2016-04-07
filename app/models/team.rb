class Team < ActiveRecord::Base
  belongs_to :class_room

  has_many :class_teams, dependent: :destroy
  has_many :users, through: :class_teams

  accepts_nested_attributes_for :class_teams, allow_destroy: true

  ATTRIBUTES_PARAMS = [:name, :class_room_id,
    class_teams_attributes: [:id, :user_id, :team_id, :_destroy]]
end
