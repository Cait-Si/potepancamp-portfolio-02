FactoryBot.define do
  factory :post do
    title { 'test_title' }
    person{ 1 }
    level { '初心者歓迎' }
    datetime { Time.now.tomorrow }
    location { 'test_location' }
    description { 'test_discription' }
    deadline { Time.now }
    user

    trait :skip_validation do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
