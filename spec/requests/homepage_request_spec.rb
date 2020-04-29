require 'rails_helper'

RSpec.describe "Homepages", type: :request do
  let(:user) { FactoryBot.attributes_for(:user) }
  describe "GET /" do
    it "適切なレスポンスを返す" do
      get root_path
      expect(response).to be_successful   # be_successはRails6から削除された
    end
  end
end
