class CreatePositionRequests < ActiveRecord::Migration
  def change
    create_table :position_requests do |t|
      t.integer :position_id
      t.integer :applicant_id
      t.integer :status, :default => 10
      t.string :token

      t.timestamps
    end
  end
end
