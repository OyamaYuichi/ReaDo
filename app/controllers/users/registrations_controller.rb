class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: %i[update destroy]

  def check_guest
    if resource.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの変更・削除できません。'
    end
  end

  def build_resource(hash={})
    hash[:uid] = User.create_unique_string
    super
  end

  protected
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
