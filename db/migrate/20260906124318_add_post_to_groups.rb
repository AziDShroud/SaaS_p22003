class AddPostToGroups < ActiveRecord::Migration[8.1]
  def change
    add_reference :groups, :post, null: true, foreign_key: true
  end
end
