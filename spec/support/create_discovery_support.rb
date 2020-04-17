module CreateDiscovery
  def create_one_discovery(discovery)
    visit new_discovery_path
    fill_in "Post anything you notice!", with: discovery.content
    click_button "Post"
  end
end

RSpec.configure do |config|
  config.include CreateDiscovery
end
