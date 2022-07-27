FactoryBot.define do
  factory :user do
    name { 'test_user' }
    email { 'test@test.com' }
    password { '123123' }
  end
end
