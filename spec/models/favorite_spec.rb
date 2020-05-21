require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:favorite) { FactoryBot.create(:favorite) }

  it "user_idがない場合は無効であること" do
    favorite.user_id = nil
    expect(favorite).to_not be_valid
  end

  it "discovery_idまたはcomment_idがある場合は有効であること" do
    expect(favorite).to be_valid
    favorite.discovery_id = nil
    expect(favorite).to be_valid
    favorite.discovery_id = true
    favorite.comment_id = nil
    expect(favorite).to be_valid
  end

  it "discovery_id,comment_idがない場合は無効であること" do
    favorite.discovery_id = nil
    favorite.comment_id = nil
    expect(favorite).to_not be_valid
  end
  
end
