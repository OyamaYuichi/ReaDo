FactoryBot.define do
  factory :user do
    id { 1 }
    name { 'user1' }
    email { 'user1@sample.com' }
    password { "password" }
  end
  factory :user2, class: User do
    id { 2 }
    name { 'user2' }
    email { 'user2@sample.com' }
    password { 'password' }
  end
end
