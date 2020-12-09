class UserMailer < ApplicationMailer
  def notify_user
    # default to: -> { current_user.email }
    # mail(subject: "everyday Bookers!yay!")
    # mail to: "#{current_user.email}", subject: "投稿確認メール"
    # mail to: "user@sample.com", subject: "投稿確認メール"
    mail to: "yuichi19991208@gmail.com", subject: "投稿確認メール"
  end
end
