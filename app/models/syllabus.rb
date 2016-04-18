class Syllabus < ActiveRecord::Base
  belongs_to :course

  has_many :syllabus_details, dependent: :destroy
end
