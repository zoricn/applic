class AddLastSeenPositionRequest < ActiveRecord::Migration
  def change
  	add_column :position_requests, :last_seen_at, :datetime
  end
end
