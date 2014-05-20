class AddApplicantToPositionRequests < ActiveRecord::Migration
  def change
  	add_column :position_requests, :applicant, :hstore
  	execute "CREATE INDEX position_requests_applicant ON position_requests USING GIN(applicant)"
  end
end
