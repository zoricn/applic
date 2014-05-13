class AddPositionRequestIdToApplicant < ActiveRecord::Migration
  def change
  	add_column :applicants, :position_request_id, :integer
  end
end
