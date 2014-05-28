FactoryGirl.define do
	factory :position do
    sequence(:title) { |n| "title#{n}" }
    description "This is my description"
    user
    fields [{"name"=>"email", "question"=>"Email?"}, {"name"=>"name", "question"=>"What is your name?"}]
  end
end

