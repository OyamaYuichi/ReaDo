class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
          :rememberable, :validatable, :trackable, :omniauthable, omniauth_providers: %i(google)

  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.find_for_google(auth)
    user = User.find_by(email: auth.info.email)
    unless user
      user = User.new(email: auth.info.email,
                      provider: auth.provider,
                      uid:      auth.uid,
                      password: Devise.friendly_token[0, 20],
                      )
    end
    user.save
    user
  end

  has_many :summaries, dependent: :destroy
  mount_uploader :icon, ImageUploader
end
