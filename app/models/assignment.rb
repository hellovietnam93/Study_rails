class Assignment < ActiveRecord::Base
  has_many :assignment_submits, dependent: :destroy
  has_many :assignment_histories, dependent: :destroy
  has_many :reminders, as: :reminderable


  belongs_to :class_room
  belongs_to :reminderable, polymorphic: true

  ATTRIBUTES_PARAMS = [:name, :class_room_id, :content, :start_time, :end_time]

  validate :end_time_must_be_greater_than_start_time
  validate :time_must_be_in_time_of_semester
  validates :name, presence: true

  private
  def end_time_must_be_greater_than_start_time
    errors.add :base, I18n.t("assignments.validates.error_date") if end_time <= start_time
  end

  def time_must_be_in_time_of_semester
    unless start_time > class_room.semester.start_date and end_time < class_room.semester.end_date
      errors.add :base, I18n.t("assignments.validates.error_date_semester")
    end
  end
end
