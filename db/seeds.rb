Faker::Config.locale = :ja
require "csv"

CSV.foreach('db/Book.csv', headers: true) do |row|
  Book.create(
    title: row['title'],
    image_url: row['image_url'],
    url: row['url'],
    author: row['author'],
    publisher: row['publisher'],
    isbn: row['isbn']
  )
end

100.times do |i|
  user = User.new(
          name: Faker::Name.name,
          email: "user#{i}@sample.com",
          password: "user#{i}@sample.com",
          uid: "#{i}",
          level: rand(100)
        )
  user.save!
end

500.times do |i|
  Summary.create!(
    content: Faker::Lorem.paragraph_by_chars(number: 2000, supplemental: false),
    category: rand(18),
    user_id: rand(1..100),
    book_id: rand(1..35),
  )
end

500.times do |i|
  Memo.create(
    content: Faker::Lorem.paragraph_by_chars(number: 300, supplemental: false),
    action_plan: Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4),
    user_id: rand(1..100),
    book_id: rand(1..35),
  )
end

1000.times do |i|
  Comment.create(
    content: Faker::Lorem.paragraph_by_chars(number: 300, supplemental: false),
    user_id: rand(1..100),
    summary_id: rand(1..500),
  )
end

1000.times do |i|
  Review.create(
    content: Faker::Lorem.paragraph_by_chars(number: 300, supplemental: false),
    user_id: rand(1..100),
    book_id: rand(1..35),
  )
end

1000.times do |i|
  Favorite.create(
    user_id: rand(1..100),
    summary_id: rand(1..500),
  )
end

1000.times do |i|
  Relationship.create(
    follower_id: rand(1..100),
    followed_id: rand(1..100),
  )
end


# User.all.each do |user|
#   calc_level = user.summaries.count * 0.6
#               + user.memos.count * 0.2
#               + user.comments.count * 0.1
#               + user.reviews.count * 0.1
#   user.update(level: calc_level.floor)
# end
