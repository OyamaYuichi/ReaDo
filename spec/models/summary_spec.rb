require 'rails_helper'

describe '要約モデル機能', type: :model do
  describe 'バリデーションのテスト' do
    before do
      @user1 = FactoryBot.create(:user)
      @book1 = FactoryBot.create(:book)
    end
    context '要約のカテゴリーが空の場合' do
      it 'バリデーションにひっかかる' do
        summary = Summary.new( category: '', content: '嫌われる勇気の要約', user: @user1, book: @book1)
        expect(summary).not_to be_valid
      end
    end
    context '要約の内容が空の場合' do
      it 'バリデーションにひっかかる' do
        summary = Summary.new( category: 'self_help', content: '', user: @user1, book: @book1)
        expect(summary).not_to be_valid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        summary = Summary.new( category: 'self_help', content: '嫌われる勇気の要約', user: @user1, book: @book1)
        expect(summary).to be_valid
      end
    end
  end


  describe '検索機能' do
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

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索キーワードを含む書籍が絞り込まれる" do
        expect(Book.get_by_title('嫌われる')).to include(@book1)
        expect(Book.get_by_title('嫌われる')).not_to include(@book2)
        expect(Book.get_by_title('嫌われる')).not_to include(@book3)
        expect(Book.get_by_title('嫌われる').count).to eq 1
      end
    end
    context 'scopeメソッドで著者名のあいまい検索をした場合' do
      it "検索キーワードを含む書籍が絞り込まれる" do
        expect(Book.get_by_author('コヴィー')).to include(@book3)
        expect(Book.get_by_author('コヴィー')).not_to include(@book2)
        expect(Book.get_by_author('コヴィー')).not_to include(@book1)
        expect(Book.get_by_author('コヴィー').count).to eq 1
      end
    end
    context 'scopeメソッドでカテゴリー検索をした場合' do
      it "カテゴリーに完全一致する要約が絞り込まれる" do
        expect(Summary.get_by_category('self_help')).to include(@summary1)
        expect(Summary.get_by_category('self_help')).to include(@summary2)
        expect(Summary.get_by_category('self_help')).to include(@summary3)
        expect(Summary.get_by_category('self_help').count).to eq 3
      end
    end
    context 'scopeメソッドでタイトルと著者名のあいまい検索をした場合' do
      it "検索キーワードをタイトル、著者名に含む書籍が絞り込まれる" do
        expect(Book.get_by_title('嫌われる').get_by_author('岸見')).to include(@book1)
        expect(Book.get_by_title('嫌われる').get_by_author('岸見')).not_to include(@book2)
        expect(Book.get_by_title('嫌われる').get_by_author('岸見')).not_to include(@book3)
        expect(Book.get_by_title('嫌われる').get_by_author('岸見').count).to eq 1
      end
    end
  end
end