class Api::UsersController < ActionController::API
  def current_user
    user = User.find_by(id: session[:user_id])
    render json: user
  end
end
