3.times do |n|
  user = User.new(
    name: "test_user_#{ n+1 }",
    email: "test_#{ n+1 }@test.com",
    password: 123123
  )

  user.save!

  5.times do |m|
    Post.create!(
      title: "test_title_#{ m+1 }",
      person: n+1,
      datetime: Time.new(2022, 9, m+2, 12, 8),
      location: "test_location_#{ m+1 }",
      level: "初心者歓迎",
      description: "test_discription_#{ m+1 }",
      deadline: Time.new(2022, 9, m+1, 12, 8),
      user_id: user.id,
    )
  end
end
