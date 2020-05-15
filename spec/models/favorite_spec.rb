require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:favorite) { FactoryBot.build(:favorite) }

  it "user_idがない場合は無効であること" do
    favorite.user_id = nil
    expect(favorite).to_not be_valid
  end

  it "discovery_idがない場合は無効であること" do
    favorite.discovery_id = nil
    expect(favorite).to_not be_valid
  end
end
