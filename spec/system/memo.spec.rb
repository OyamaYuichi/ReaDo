require 'rails_helper'
RSpec.describe '読書メモ機能', type: :system do
  def user_login
    visit new_user_session_path
    fill_in 'メールアドレス', with: 'user1@sample.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user2)
    @user3 = FactoryBot.create(:user3)

    @book1 = FactoryBot.create(:book)
    @book2 = FactoryBot.create(:second_book)
    @book3 = FactoryBot.create(:third_book)

    @memo1 = FactoryBot.create(:memo, content: '嫌われる勇気のメモ', action_plan: "嫌われる勇気のアクションプラン", user: @user1, book: @book1)
    @memo2 = FactoryBot.create(:second_memo, content: '幸せになる勇気のメモ', action_plan: "幸せになる勇気のアクションプラン", user: @user2, book: @book2)
    @memo3 = FactoryBot.create(:third_memo, content: '7つの習慣のメモ', action_plan: "7つの習慣のアクションプラン",  user: @user3, book: @book3)
  end


  describe '新規作成機能' do
    context 'メモを新規作成した場合' do
      it '作成したユーザープロフィールのメモ一覧に表示される' do
        user_login
        visit new_book_path
        create_btns = all('.create-memo')
        create_btns[0].click
        fill_in "content",	with: "嫌われる勇気のメモ"
        fill_in "action_plan",	with: "嫌われる勇気のアクションプラン"
        click_on '投稿'
        expect(current_path).to eq summaries_path
        profile_btn = all('.user')
        profile_btn[0].click
        memo_btn = all('.select-text')
        memo_btn[0].click
        expect(page).to have_content '嫌われる勇気'
        end
      end
    end


  describe '一覧表示機能' do
    context '任意のユーザーのプロフィール画面に遷移した場合' do
      it '選択したユーザーの作成したメモ一覧が表示される' do
        user_login
        visit user_path(1)
        memo_btn = all('.select-text')
        memo_btn[0].click
        expect(page).to have_content '嫌われる勇気'
        expect(page).not_to have_content '幸せになる勇気'
        expect(page).not_to have_content '7つの習慣'
        visit user_path(2)
        memo_btn = all('.select-text')
        memo_btn[0].click
        expect(page).not_to have_content '嫌われる勇気'
        expect(page).to have_content '幸せになる勇気'
        expect(page).not_to have_content '7つの習慣'
        visit user_path(3)
        memo_btn = all('.select-text')
        memo_btn[0].click
        expect(page).not_to have_content '嫌われる勇気'
        expect(page).not_to have_content '幸せになる勇気'
        expect(page).to have_content '7つの習慣'
      end
    end
  end


  describe '詳細表示機能' do
    context '任意のメモ詳細画面に遷移した場合' do
      it '該当のメモの内容が表示される' do
        user_login
        visit user_path(1)
        memo_btn = all('.select-text')
        memo_btn[0].click
        images = all('.summary-image')
        images[0].click
        expect(page).to have_content '嫌われる勇気のメモ'
        expect(page).to have_content '嫌われる勇気のアクションプラン'
      end

      it '該当の要約の書籍情報が表示される' do
        user_login
        visit user_path(1)
        memo_btn = all('.select-text')
        memo_btn[0].click
        images = all('.summary-image')
        images[0].click
        expect(page).to have_content '嫌われる勇気'
        expect(page).to have_content '岸見一郎/古賀史健'
        expect(page).to have_content 'ダイヤモンド社'
      end
    end
  end

end