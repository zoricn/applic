class Applicant < ActiveRecord::Base
	has_many :position_requests
    has_many :positions, through: :position_requests
end
