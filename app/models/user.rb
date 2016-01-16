class User < ActiveRecord::Base
  has_many :user_classes
  has_many :class_rooms, through: :user_classes
  has_many :group_classes, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  extend FriendlyId
  friendly_id :email, use: :slugged
end
