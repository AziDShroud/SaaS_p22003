class ChangeGroupIdNullInConversations < ActiveRecord::Migration[8.1]
  def change
    change_column_null :conversations, :group_id, true
  end
end
