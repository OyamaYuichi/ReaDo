FactoryBot.define do
  factory :memo do
    content { 'test_content' }
    action_plan { 'memo1_action_plan' }
    email_send { "false" }
    user
    book
  end

  factory :second_memo, class: Memo do
    content { 'test2_content' }
    action_plan { 'memo2_action_plan' }
    email_send { "false" }
    user
    book
  end

  factory :third_memo, class: Memo do
    content { 'test3_content' }
    action_plan { 'memo3_action_plan' }
    email_send { "false" }
    user
    book
  end
end