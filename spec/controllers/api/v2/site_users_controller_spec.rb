require 'rails_helper'
require 'fileutils'

describe Api::V2::SiteUsersController do

  before :each do
    @user = create(:user)
    @valid_api_key = @user.api_key
    @site = create(:site)
    @good_data = {
      :site_user => "{
        :site => '#{@site.uid}',
        :user => '#{@user.email}'
      }"
    }
    @bad_data = {
      :empty_site => { :site_user => "{ :site => '', :user => '#{@user.email}' }" },
      :empty_user => { :site_user => "{ :site => '#{@site.uid}', :user => '' }" },
      :wrong_site => { :site_user => "{ :site => '0', :user => '#{@user.email}' }" },
      :wrong_user => { :site_user => "{ :site => '#{@site.uid}', :user => '0' }" }
    }
    @missing_attrs = { :site_user => {} }
    @empty_data = {}
  end

  context 'When adding a site user' do
    context 'with a missing API key' do
      it 'returns 401' do
        post :create, :format => 'json'
        expect(response.status).to eq(401)
      end
    end
    context 'with an invalid API key' do
      it 'returns 401' do
        @request.headers['X-Api-Key'] = '123'
        post :create, :format => 'json'
        expect(response.status).to eq(401)
      end
    end
    context 'with a valid API key' do
      ['site','user'].each do |attr|
        context "and an empty #{attr}" do
          it 'returns 500' do
            @request.headers['X-Api-Key'] = @valid_api_key
            post :create, @bad_data[:"empty_#{attr}"].merge(:format => 'json')
            expect(response.status).to eq(500)
          end
        end
        context "and a missing #{attr}" do
          it 'returns 500' do
            @request.headers['X-Api-Key'] = @valid_api_key
            post :create, @bad_data[:"wrong_#{attr}"].merge(:format => 'json')
            expect(response.status).to eq(500)
          end
        end
      end
      context 'and missing data' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @missing_attrs.merge(:format => 'json')
          expect(response.status).to eq(500)
        end
      end
      context 'and good data' do
        it 'returns 200' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @good_data.merge(:format => 'json')
          expect(response.status).to eq(200)
        end
        it "returns the default config" do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @good_data.merge(:format => 'json')
          expect(JSON.parse(response.body)['site']).to eq(@site.uid)
        end
      end
    end
  end

end
