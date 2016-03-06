class Like < ActiveRecord::Base
  belongs_to :user

  scope :find_by_target, ->table_name, target_id {where target_id: target_id, target_type: table_name}
end
