class Semester < ActiveRecord::Base
  has_many :class_rooms, dependent: :destroy

  validates :name, presence: true, length: {maximum: 8}
  validate :end_date_must_be_greater_than_start_date

  ATTRIBUTES_PARAMS = [:name, :start_date, :end_date]

  private
  def end_date_must_be_greater_than_start_date
    errors.add :base, I18n.t("semesters.validate.date") if end_date <= start_date
  end
end
