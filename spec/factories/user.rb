FactoryGirl.define do
  factory :test_user, class: User do
    name "test"
    password "example"
    email "test@example.com"
  end
end
