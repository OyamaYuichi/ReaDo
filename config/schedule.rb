# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# 絶対パスから相対パス指定
env :PATH, ENV['PATH']
# env :GEM_PATH, ENV['GEM_PATH']
# ログファイルの出力先
# set :output, "/path/to/my/cron_log.log"
set :output, 'log/cron.log'
# ジョブの実行環境の指定
set :environment, :development
#
# rbenvを初期化
# set :job_template, "/bin/zsh -l -c ':job'"
set :job_template, "$(which zsh) -l -c 'source $HOME/.zshrc; :job'"
job_type :rake, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && RAILS_ENV=:environment bundle exec rake :task :output"
#
every 1.minutes do
# every 1.days, at: '7:00 am' do
# Rails内のメソッド実行
  runner "User.all.each { |user| UserMailer.notify_user(user: user).deliver }"
  # runner "UserMailer.notify_user.deliver"
end
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
