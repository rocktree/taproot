require 'rails_helper'
require 'fileutils'

describe Api::V2::SitesController do

  before :all do
    user = create(:user)
    @valid_api_key = user.api_key
    @title = 'Hello World 123'
    @good_data = {
      :site => "{
        :title => '#{@title}'
      }"
    }
    @empty_title = { :site => "{ :title => '' }" }
    @missing_title = { :site => {} }
    @empty_data = {}
    @config_01 = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @config_01_data = { :site => "#{@config_01}" }
  end

  before :each do
    site = Site.find_by_title(@title)
    site.destroy unless site.nil?
  end

  context 'When creating a site' do
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
      context 'and an empty title' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @empty_title.merge(:format => 'json')
          expect(response.status).to eq(500)
        end
      end
      context 'and a missing title' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @missing_title.merge(:format => 'json')
          expect(response.status).to eq(500)
        end
      end
      context 'and missing data' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @empty_data.merge(:format => 'json')
          expect(response.status).to eq(500)
        end
      end
      context 'and a title' do
        it 'returns 200' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @good_data.merge(:format => 'json')
          expect(response.status).to eq(200)
        end
        it "returns the default config" do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @good_data.merge(:format => 'json')
          @site = Site.find_by_title(@title)
          expect(JSON.parse(response.body)).to eq(@site.config)
        end
      end
    end
  end

  context 'When updating a site' do
    before(:each) do
      @site = create(:site, :title => 'Hello World 123')
      @uid = @site.uid
    end
    after(:each) do
      @site.destroy
    end
    context 'with a missing API key' do
      it 'returns 401' do
        post :update, :format => 'json', :uid => @uid
        expect(response.status).to eq(401)
      end
    end
    context 'with an invalid API key' do
      it 'returns 401' do
        @request.headers['X-Api-Key'] = '123'
        post :update, :format => 'json', :uid => @uid
        expect(response.status).to eq(401)
      end
    end
    context 'with a valid API key' do
      context 'and missing data' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :update, @empty_data.merge(:format => 'json', :uid => @uid)
          expect(response.status).to eq(500)
        end
      end
      context 'and good data' do
        it 'returns 200' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :update, @config_01_data.merge(:format => 'json', :uid => @uid)
          expect(response.status).to eq(200)
        end
        it 'returns the config' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :update, @config_01_data.merge(:format => 'json', :uid => @uid)
          @site.reload
          expect(JSON.parse(response.body)).to eq(@site.config)
        end
      end
    end
  end

  # context 'When deploying a site' do
  #   context 'with a missing API key' do
  #     it 'returns 401' do
  #       post :deploy, :format => 'json'
  #       expect(response.status).to eq(401)
  #     end
  #   end
  #   context 'with an invalid API key' do
  #     it 'returns 401' do
  #       @request.headers['X-Api-Key'] = '123'
  #       post :deploy, :format => 'json'
  #       expect(response.status).to eq(401)
  #     end
  #   end
  #   context 'with a valid API key' do
  #     context 'and a valid uid' do
  #       it 'will deploy a site that already exists' do
  #         @request.headers['X-Api-Key'] = @valid_api_key
  #         post :create, @good_data.merge(:format => 'json')
  #         post :deploy, @uid_data.merge(:format => 'json')
  #         expect(response.status).to eq(200)
  #       end
  #       it 'returns 500 when the site files do not exist' do
  #         @request.headers['X-Api-Key'] = @valid_api_key
  #         post :deploy, @uid_data.merge(:format => 'json')
  #         expect(response.status).to eq(500)
  #       end
  #     end
  #     context 'and an invalid uid' do
  #       it 'returns 500 when the uid is empty' do
  #         @request.headers['X-Api-Key'] = @valid_api_key
  #         post :create, @good_data.merge(:format => 'json')
  #         post :deploy, @empty_uid.merge(:format => 'json')
  #         expect(response.status).to eq(500)
  #       end
  #       it 'returns 500 when the uid is wrong' do
  #         @request.headers['X-Api-Key'] = @valid_api_key
  #         post :create, @good_data.merge(:format => 'json')
  #         post :deploy, @wrong_uid.merge(:format => 'json')
  #         expect(response.status).to eq(500)
  #       end
  #       it 'returns 500 when the uid is missing' do
  #         @request.headers['X-Api-Key'] = @valid_api_key
  #         post :create, @good_data.merge(:format => 'json')
  #         post :deploy, @missing_uid.merge(:format => 'json')
  #         expect(response.status).to eq(500)
  #       end
  #     end
  #   end
  # end

end
