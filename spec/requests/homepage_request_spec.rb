require 'rails_helper'

RSpec.describe "Homepages", type: :request do
  describe "GET /" do
    it "正常なレスポンスを返す" do
      get root_path
      expect(response).to be_successful   # be_successはRails6から削除された
    end
  end
end
