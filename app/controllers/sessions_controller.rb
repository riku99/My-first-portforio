class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(acount_id: params[:session][:acount_id])
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      redirect_to user
    else
      # flashは次のリクエストのまで残る。.nowは次のリクエストがあった時点で消える
      flash.now[:danger] = "User_idまたはpasswordが正しくありません"
      render "new"
    end
  end

  # if logged_inはforgetメソッドでcurrent_userのオブジェクトを必要とするため、current_userがnil場合はlog_outは行われないようにする
  # 同じブラウザの異なるタブで片方がログアウトするとsessionがなくなりcurrent_userがもう片方のタブでnilになりエラーになってしまうため
  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
