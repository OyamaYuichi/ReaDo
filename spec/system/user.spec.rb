require 'rails_helper'
RSpec.describe 'ユーザ登録・ログイン・ログアウト機能', type: :system do

  def user_login
    visit new_user_session_path
    fill_in 'メールアドレス', with: 'sample@dic.com'
    fill_in 'パスワード', with: 'samplesample'
    click_button 'ログイン'
  end

  describe 'ユーザ登録のテスト' do
    context 'ユーザのデータがなくログインしていない状態' do
      it 'ユーザ新規登録のテスト' do
        visit new_user_registration_path
        fill_in "ユーザーネーム",	with: "user1"
        fill_in "メールアドレス",	with: "user1@sample.com"
        fill_in "パスワード",	with: "password"
        fill_in "確認用パスワード",	with: "password"
        click_button 'アカウント登録'
        profile_btns = all('.user')
        profile_btns[0].click
        expect(page).to have_content 'user1'
      end

      it 'ユーザがログインせず投稿画面に飛ぼうとしたとき、ログイン画面に遷移' do
        visit new_user_registration_path
        visit new_book_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'セッション機能のテスト' do
    before do
      @user = FactoryBot.create(:user)
      user_login
    end

    context 'ログインしていない状態でユーザーのデータがある場合' do
      it 'ログインができること' do
        expect(page).to have_content 'ログインしました'
      end
    end

    context 'ユーザーがログインしている状態' do
      it '自分の詳細画面（マイページ）に飛べること' do
        visit summaries_path
        # binding.pry
        profile_btn = all('.user')
        profile_btn[0].click

        expect(current_path).to eq user_path(1)
      end

      it 'ログアウトができること' do
        logout_btn = all('.fa-sign-out-alt')
        logout_btn[0].click
        expect(page.accept_confirm).to eq "ログアウトしますか？"
        expect(page).to have_content "ログアウトしました"
      end
    end
  end
end