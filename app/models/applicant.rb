class Applicant < ActiveRecord::Base

	belongs_to :position_request
	#has_many :position_requests
    #has_many :positions, through: :position_requests
end
