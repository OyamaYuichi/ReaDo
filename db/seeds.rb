Faker::Config.locale = :ja

# 30.times do |i|
#   user = User.new(
#           name: "user#{i + 1}",
#           email: "user#{i + 1}@sample.com",
#           password: "user#{i + 1}@sample.com",
#           uid: "#{i + 1}"
#         )
#   user.save!
# end

100.times do |i|
  Summary.create!(
    content: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
    user_id: rand(9..38),
    book_id: rand(1..5),
  )
end
