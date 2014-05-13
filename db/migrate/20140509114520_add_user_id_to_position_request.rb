class AddUserIdToPositionRequest < ActiveRecord::Migration
  def change
  	add_column :position_requests, :user_id, :integer
  end
end
