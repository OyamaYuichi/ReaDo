class Users::RegistrationsController < Devise::RegistrationsController
  def build_resource(hash={})
    hash[:uid] = User.create_unique_string
    super
  end

  protected
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
