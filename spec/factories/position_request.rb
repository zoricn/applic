FactoryGirl.define do
  factory :position_request do
  	position
  	status PositionRequest::STATUS_PENDING
  	applicant "email" => "office@kolosek.com"
  end
end