module CreateDiscovery
  def create_one_discovery(discovery)
    visit new_discovery_path
    fill_in "勉強して気づいたこと、発見したことをなんでも投稿しよう！", with: discovery.content
    click_button "Post"
  end
end

RSpec.configure do |config|
  config.include CreateDiscovery
end
