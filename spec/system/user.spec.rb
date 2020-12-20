require 'rails_helper'
RSpec.describe 'ユーザ登録・ログイン・ログアウト機能', type: :system do

  def user_login
    visit new_user_session_path
    fill_in 'メールアドレス', with: 'user1@sample.com'
    fill_in 'パスワード', with: 'password'
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
        profile_btn = all('.user')
        profile_btn[0].click
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


  describe 'フォロー機能のテスト' do
    before do
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user2)
      @user3 = FactoryBot.create(:user3)
      user_login
    end
    context '自分以外のユーザーデータがあり、ログインしている状態' do
      it '自分以外のユーザーのプロフィールには、フォローボタンが表示される' do
        visit user_path(2)
        expect(page).to have_content 'フォロー'
        visit user_path(3)
        expect(page).to have_content 'フォロー'
      end
    end
    context 'user1がuser2をフォローしている状態' do
      it 'user1のフォロー一覧にuser2が表示される' do
        visit user_path(2)
        expect(page).to have_content 'フォロー'
        click_on 'フォロー'
        profile_btn = all('.user')
        profile_btn[0].click
        follow_btn = all('#follow')
        follow_btn[0].click
        expect(page).to have_content 'user2'
      end
      it 'user2のフォロワー一覧にuser1が表示される' do
        visit user_path(2)
        expect(page).to have_content 'フォロー'
        click_on 'フォロー'
        follow_btn = all('#follower')
        follow_btn[0].click
        expect(page).to have_content 'user1'
      end
    end
  end

end