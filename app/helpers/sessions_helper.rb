module SessionsHelper

  # sessionメソッドにより、ブラウザのcookieのuser_idというキーにユーザーのidを値として入れる
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # session中のユーザー(ブラウザのcookieに保存されてるidのユーザー)またはnilを返す
  def current_user
    if session[:user_id]
      # .findだとログインしてなくidの値がnilの場合にエラーが発生してしまう
      # ログインしている状態とそうでない状態でただrailsの振る舞いを分けたいだけなのでエラーではなくnilを返すのが好ましいためfind_byを使用
      # インスタンス変数に結果を代入することで以後の値の呼び出しをメソッドではなく変数で指定できる
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ログインしているか(cookieにidがあるか(current_userがnilでないか))を返す
  def logged_in?
    !current_user.nil?
  end

end
