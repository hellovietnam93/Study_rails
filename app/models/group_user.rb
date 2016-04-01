class GroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  enum status: [:waiting, :take_in]
end
