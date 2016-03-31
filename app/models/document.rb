class Document < ActiveRecord::Base
  belongs_to :user
  belongs_to :class_room

  mount_uploader :attachment, AttachmentUploader
  validates :title, presence: true
  validates :user, presence: true
end
