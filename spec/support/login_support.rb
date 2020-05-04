module LoginUser
  def is_logged_in?
    !session[:user_id].nil?
  end

  def test_log_in
    visit login_path
    fill_in "User_id", with: user.acount_id
    fill_in "Password", with: user.password
    click_button "Login"
  end

  RSpec.configure do |config|
    config.include LoginUser
  end
end
