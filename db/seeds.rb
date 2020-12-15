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

# 100.times do |i|
#   Summary.create!(
#     content: Faker::Lorem.paragraph_by_chars(number: 1000, supplemental: false),
#     category: rand(18),
#     user_id: rand(1..30),
#     book_id: rand(1..15),
#   )
# end

# User.all.each do |user|
#   calc_level = user.summaries.count * 0.6 + user.memos.count * 0.2
#   user.level = calc_level.floor
# end
