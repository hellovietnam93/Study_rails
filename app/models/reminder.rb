class Reminder < ActiveRecord::Base
  belongs_to :user
  belongs_to :reminderable, polymorphic: true

  enum remind_type: [:start_lesson, :start_submit]
end
