class ClassRoom < ActiveRecord::Base
  has_many :user_classes
  has_many :users, through: :user_classes
  has_many :group_classes, dependent: :destroy
  has_many :assignments, dependent: :destroy

  belongs_to :course
  belongs_to :semester

  extend FriendlyId
  friendly_id :uid, use: [:slugged, :finders]
end
