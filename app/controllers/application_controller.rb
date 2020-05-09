class ApplicationController < ActionController::Base
  # コントローラーのスーパークラスにincludeすることで全コントローラでこのヘルパーを使用できる
  # sessionsコントローラを作成した時点で自動で作成され、viewにも自動で読み込まれる
  include SessionsHelper

  def user_logged_in?
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
end
