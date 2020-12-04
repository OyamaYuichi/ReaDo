module ApplicationHelper

  def authenticate_user
    if @current_user == nil
      flash[:notice] = 'ログインしてください'
      redirect_to new_session_path
    end
  end
end
