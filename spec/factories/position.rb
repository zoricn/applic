FactoryGirl.define do
	factory :position do
    sequence(:title) { |n| "title#{n}" }
    description "This is my description"
    user
  end
end

