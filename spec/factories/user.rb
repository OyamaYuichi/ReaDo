FactoryBot.define do
  factory :user do
    id { 1 }
    name { 'user1' }
    email { 'user1@sample.com' }
    password { "password" }
    uid { 1 }
  end
  factory :user2, class: User do
    id { 2 }
    name { 'user2' }
    email { 'user2@sample.com' }
    password { 'password' }
    uid { 2 }
  end
  factory :user3, class: User do
    id { 3 }
    name { 'user3' }
    email { 'user3@sample.com' }
    password { 'password' }
    uid { 3 }
  end
end
