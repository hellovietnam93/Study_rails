class User < ActiveRecord::Base
  has_many :user_classes
  has_many :class_rooms, through: :user_classes
  has_many :group_classes, dependent: :destroy
  has_many :online_tests, dependent: :destroy
  has_many :assignment_submits, dependent: :destroy
  has_many :assignment_histories, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable#, :confirmable, :lockable

  enum role: [:admin, :lecturer, :student]

  def like target
    likes.find_by target_id: target, target_type: target.class.table_name
  end
end
