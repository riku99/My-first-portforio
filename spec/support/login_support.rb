module LoginUser
  def is_logged_in?
    !session[:user_id].nil?
  end

  def session_log_in(user)
    @request = user
    session[:user_id] = user.id
  end

  def test_log_in(u)
    visit login_path
    fill_in "User_id", with: u.acount_id
    fill_in "Password", with: u.password
    click_button "Login"
  end

  def log_in_as
    post login_path, params: { session: FactoryBot.attributes_for(:user) }
  end

  def log_in_as_second_user
    post login_path, params: { session: FactoryBot.attributes_for(:user, :second_user) }
  end

  RSpec.configure do |config|
    config.include LoginUser
  end
end
