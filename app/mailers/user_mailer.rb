class UserMailer < ApplicationMailer
  def notify_user(user: User.current_user)
    @memos = user.memos.where(email_send: true).order(created_at: :desc)
    # @users = User.all.select do |user|
    #   user.memos.where(email_send: true).present?
    # end
    # users_mails = @users.pluck(:email)

    # ** why mail to should write in last **
    # what: to send mail
    # how: fill mail cmp such as args -> to: email, subject: title
    # why: mail to has render

    # ** why does render move to view from controller **
    # what: to send mail
    # how: fill mail cmp such as args -> to: email, subject: title
    # why: mail to has render
    if @memos.present?
      mail to: "#{user.email}", subject: "アクションプラン更新メール"
    end
  end
end
