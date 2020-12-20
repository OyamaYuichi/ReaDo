require 'rails_helper'

describe 'ユーザーモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザーネームが空の場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: '', email: 'user@invalid.com', password: "password", uid: 1 )
        expect(user).not_to be_valid
      end
    end
    context 'ユーザーネームが30文字を越えていた場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: "a" * 31, email: 'user@invalid.com', password: "password", uid: 1 )
        expect(user).not_to be_valid
      end
    end
    context 'メールアドレスが空の場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'user', email: '', password: "password", uid: 1 )
        expect(user).not_to be_valid
      end
    end
    context 'メールアドレスがフォーマット通りでない場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'user', email: 'user.email', password: "password", uid: 1 )
        expect(user).not_to be_valid
      end
    end
    context 'メールアドレスが255文字を越えていた場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'user', email: "a" * 255 + "@invalid.com", password: "password", uid: 1 )
        expect(user).not_to be_valid
      end
    end
    context 'パスワードが空の場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'user', email: 'user@invalid.com', password: "", uid: 1 )
        expect(user).not_to be_valid
      end
    end
    context 'パスワードが6文字未満の場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'user', email: 'user@invalid.com', password: "user", uid: 1 )
        expect(user).not_to be_valid
      end
    end
    context '内容が全て正しく記載されている場合' do
      it 'バリデーションが通る' do
        user = User.new(name: 'user', email: 'user@invalid.com', password: "password", uid: 1 )
        expect(user).to be_valid
      end
    end
  end
end
