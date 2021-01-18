class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: %i[update destroy]

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      redirect_to user_path(current_user.id)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

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
