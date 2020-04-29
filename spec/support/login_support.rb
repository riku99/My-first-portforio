module LoginUser
  def is_logged_in?
    !session[:user_id].nil?
  end

  def test_logged_in(user)
    session[:user_id] = user.id
  end

  RSpec.configure do |config|
    config.include LoginUser
  end
end
