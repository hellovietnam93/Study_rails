class User < ActiveRecord::Base
  has_many :user_classes
  has_many :class_rooms, through: :user_classes
  has_many :online_tests, dependent: :destroy
  has_many :assignment_submits, dependent: :destroy
  has_many :assignment_histories, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :documents, dependent: :destroy
  has_many :class_teams, dependent: :destroy
  has_many :teams, through: :class_teams
  has_many :events, dependent: :destroy
  has_many :event_users, dependent: :destroy

  has_one :profile, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable#, :confirmable, :lockable

  enum role: [:admin, :lecturer, :student]

  mount_uploader :avatar, PictureUploader

  def like target
    likes.find_by target_id: target, target_type: target.class.table_name
  end

  def has_team_in_class? class_room
    (team_ids & class_room.team_ids).size == 1
  end
end
