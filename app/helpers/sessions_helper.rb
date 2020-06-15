module SessionsHelper

  # sessionメソッドにより、ブラウザのcookieのuser_idというキーにユーザーのidを暗号化し、値として入れる
  # sessionがあることがログインしているということなので、このメソッドでログイン状態となる
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # session中(ログイン中)のユーザー(ブラウザのcookieに保存されてるidのユーザー)またはnilを返す
  def current_user
    if (user_id = session[:user_id])
      # .findだとログインしてなくidの値がnilの場合にエラーが発生してしまう
      # ログインしている状態とそうでない状態でただrailsの振る舞いを分けたいだけなのでエラーではなくnilを返すのが好ましいためfind_byを使用
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if (user && user.authenticated?(cookies.signed[:remember_token]))
        log_in user
        @current_user ||= user
      end
    end
  end

  # ログインしているか(sessionがあるか(current_userがnilでないか))を返す
  def logged_in?
    !current_user.nil?
  end

  def remember(user)
    user.m_remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end

  def forget(user)
    user.m_forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # リクエストしたURLをsessionに保存
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # URLがセッションに保存されていたらそのURLに、それ以外は引数のpathにリダイレクト
  def redirect_requested_url(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
