require 'rails_helper'

describe Api::V2::BaseController do

  before :all do
    user = FactoryGirl.create(:user)
    @valid_api_key = user.api_key
  end

  # ------------------------------------------ Non-JSON

  context 'Non-JSON requests' do
    context 'with a missing API key' do
      it 'return 406' do
        get :test
        expect(response.status).to eq(406)
      end
    end
    context 'with a valid API key' do
      it 'return 406' do
        @request.headers['X-Api-Key'] = @valid_api_key
        get :test
        expect(response.status).to eq(406)
      end
    end
  end

  # ------------------------------------------ JSON

  context "JSON requests" do
    context 'with a missing API key' do
      it 'return 401' do
        get :test, :format => 'json'
        expect(response.status).to eq(401)
      end
    end
    context 'with a valid API key' do
      it 'return 200' do
        @request.headers['X-Api-Key'] = @valid_api_key
        get :test, :format => 'json'
        expect(response.status).to eq(200)
      end
    end
  end

end
