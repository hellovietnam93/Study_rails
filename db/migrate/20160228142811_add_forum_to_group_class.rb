class AddForumToGroupClass < ActiveRecord::Migration
  def change
    add_reference :group_classes, :forum, index: true, foreign_key: true
  end
end
