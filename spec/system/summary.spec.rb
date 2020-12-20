require 'rails_helper'
RSpec.describe '要約機能', type: :system do
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

    @summary1 = FactoryBot.create(:summary, content: '嫌われる勇気の要約', user: @user1, book: @book1)
    @summary2 = FactoryBot.create(:second_summary, content: '幸せになる勇気の要約', user: @user2, book: @book2)
    @summary3 = FactoryBot.create(:third_summary, content: '7つの習慣の要約',  user: @user3, book: @book3)
  end


  describe '新規作成機能' do
    context '要約を新規作成した場合' do
      it '作成した要約が表示される' do
        user_login

        visit new_book_path

        create_btns = all('.create-summary')
        create_btns[0].click

        fill_in_rich_text_area "summary_content", with: "嫌われる勇気の要約"
        select '自己啓発・マインド', from: "summary_category"

        click_on '投稿'
        expect(current_path).to eq summaries_path
        expect(page).to have_content '嫌われる勇気'
        end
      end
    end


  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        visit summaries_path
        expect(page).to have_content '嫌われる勇気'
        expect(page).to have_content '幸せになる勇気'
        expect(page).to have_content '7つの習慣'
      end
    end
    context '要約の投稿が作成日時の降順に並んでいる場合' do
      it '新しい要約の投稿が一番上に表示される' do
        user_login
        visit new_book_path

        create_btns = all('.create-summary')
        create_btns[0].click

        fill_in_rich_text_area "summary_content", with: "嫌われる勇気の要約"
        select '自己啓発・マインド', from: "summary_category"

        click_on '投稿'
        expect(current_path).to eq summaries_path
        summary = all('.summary-book-title')
        expect(summary[0]).to  have_content '嫌われる勇気'
      end
    end
  end


  describe '詳細表示機能' do
    context '任意の要約詳細画面に遷移した場合' do
      it '該当の要約の内容が表示される' do
        user_login
        visit summaries_path
        images = all('.summary-image')
        images[1].click
        expect(page).to have_content '幸せになる勇気の要約'
      end

      it '該当の要約の書籍情報が表示される' do
        user_login
        visit summaries_path
        images = all('.summary-image')
        images[1].click
        expect(page).to have_content '幸せになる勇気'
        expect(page).to have_content '岸見一郎/古賀史健'
        expect(page).to have_content 'ダイヤモンド社'
      end
    end
  end


  describe '検索機能' do
    before do
      user_login
      visit summaries_path
      search_btn = all('.fa-search')
      search_btn[0].click
    end
    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含む要約で絞り込まれる" do
        fill_in "タイトル",	with: "嫌われる"
        click_on '検索'
        expect(page).to have_content '嫌われる勇気'
        expect(page).not_to have_content '幸せになる勇気'
        expect(page).not_to have_content '7つの習慣'
      end
    end
    context '著者名であいまい検索をした場合' do
      it "検索キーワードを含む要約で絞り込まれる" do
        fill_in "著者",	with: "コヴィー"
        click_on '検索'
        expect(page).not_to have_content '嫌われる勇気'
        expect(page).not_to have_content '幸せになる勇気'
        expect(page).to have_content '7つの習慣'
      end
    end
    context 'カテゴリー検索をした場合' do
      it "カテゴリーに完全一致するタスクが絞り込まれる" do
        select '自己啓発・マインド', from: 'カテゴリー'
        click_on '検索'
        expect(page).to have_content '嫌われる勇気'
        expect(page).to have_content '幸せになる勇気'
        expect(page).to have_content '7つの習慣'
      end
    end
    context 'タイトルと著者名のあいまい検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        fill_in "タイトル",	with: "嫌われる"
        fill_in "著者",	with: "岸見"
        click_on '検索'
        expect(page).to have_content '嫌われる勇気'
        expect(page).not_to have_content '幸せになる勇気'
        expect(page).not_to have_content '7つの習慣'
      end
    end
    context 'タイトルのあいまい検索とカテゴリー検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        fill_in "タイトル",	with: "嫌われる"
        select '自己啓発・マインド', from: 'カテゴリー'
        click_on '検索'
        expect(page).to have_content '嫌われる勇気'
        expect(page).not_to have_content '幸せになる勇気'
        expect(page).not_to have_content '7つの習慣'
      end
    end
    context '著者名のあいまい検索とカテゴリー検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        fill_in "著者",	with: "岸見"
        select '自己啓発・マインド', from: 'カテゴリー'
        click_on '検索'
        expect(page).to have_content '嫌われる勇気'
        expect(page).to have_content '幸せになる勇気'
        expect(page).not_to have_content '7つの習慣'
      end
    end
  end

end

