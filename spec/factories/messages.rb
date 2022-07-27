FactoryBot.define do
  factory :message do
    content { 'こんにちは' }
    user
    post
  end
end
