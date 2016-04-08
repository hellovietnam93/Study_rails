class EventUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  enum status: [:unseen, :seen]
end
