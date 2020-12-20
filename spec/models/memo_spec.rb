require 'rails_helper'

describe 'メモモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    before do
      @user1 = FactoryBot.create(:user)
      @book1 = FactoryBot.create(:book)
    end
    context 'メモの内容が空の場合' do
      it 'バリデーションにひっかかる' do
        memo = Memo.new( action_plan: '嫌われる勇気のアクションプラン', content: '', user: @user1, book: @book1)
        expect(memo).not_to be_valid
      end
    end
    context 'アクションプランの内容が空の場合' do
      it 'バリデーションにひっかかる' do
        memo = Memo.new( action_plan: '', content: '嫌われる勇気の要約', user: @user1, book: @book1)
        expect(memo).not_to be_valid
      end
    end
    context 'メモとアクションプランの内容が記載されている場合' do
      it 'バリデーションが通る' do
        memo = Memo.new( action_plan: '嫌われる勇気のアクションプラン', content: '嫌われる勇気の要約', user: @user1, book: @book1)
        expect(memo).to be_valid
      end
    end
  end

end