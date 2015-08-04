require 'rails_helper'

describe Api::V2::DataController do

  before :all do
    user = FactoryGirl.create(:user)
    @valid_api_key = user.api_key
  end

  context 'A missing API key' do
    it 'returns 401' do
      post :export, :format => 'json'
      expect(response.status).to eq(401)
    end
  end

  context 'An invalid API key' do
    it 'returns 401' do
      @request.headers['X-Api-Key'] = '123'
      post :export, :format => 'json'
      expect(response.status).to eq(401)
    end
  end

  context 'A valid API key' do
    it 'returns 200' do
      @request.headers['X-Api-Key'] = @valid_api_key
      post :export, :format => 'json'
      expect(response.status).to eq(200)
    end
    # Tough to test anything else here. Ideally, we'd look through the actual
    # data.yml file. But if we're getting a 200, then we have the content, so
    # it's up to Topkit CLI to handle the data.
  end

end
