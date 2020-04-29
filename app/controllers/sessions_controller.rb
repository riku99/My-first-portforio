class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(acount_id: params[:session][:acount_id])
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      # flashは次のリクエストのまで残る。.nowは次のリクエストがあった時点で消える
      flash.now[:danger] = "User_idまたはpasswordが正しくありません"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
