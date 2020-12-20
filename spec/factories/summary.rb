FactoryBot.define do
  factory :summary do
    category { 'self_help' }
    content { 'test_content' }
    user
    book
  end

  factory :second_summary, class: Summary do
    category { 'self_help' }
    content { 'test2_content' }
    user
    book
  end

  factory :third_summary, class: Summary do
    category { 'self_help' }
    content { 'test3_content' }
    user
    book
  end
end