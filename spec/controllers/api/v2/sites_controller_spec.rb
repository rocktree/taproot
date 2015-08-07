require 'rails_helper'
require 'fileutils'

describe Api::V2::SitesController do

  before :all do
    user = create(:user)
    @valid_api_key = user.api_key
    @good_data = {
      :site => "{
        :git_url => 'git@github.com:topicdesign/topkit-test-template.git'
      }"
    }
    @empty_git_url = { :site => { :git_url => '' } }
    @missing_git_url = { :site => {} }
    @empty_data = {}
    @uid = '69b0386a13b44503881d516a2c19cc4a2bf48974d552a397'
    @uid_data = {
      :site => "{
        :uid => #{@uid}
      }"
    }
  end

  before :each do
    project_dir = "#{Rails.root}/projects/hello-world-123"
    FileUtils.rm_r(project_dir) if Dir.exists?(project_dir)
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
      context 'and a valid git_url' do
        it 'returns 200' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @good_data.merge(:format => 'json')
          expect(response.status).to eq(200)
        end
        it 'renames the project in the projects directory' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @good_data.merge(:format => 'json')
          expect(
            Dir.exists?("#{Rails.root}/projects/hello-world-123")
          ).to eq(true)
        end
        it 'creates a site in the database' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @good_data.merge(:format => 'json')
          site = Site.where(
            :title => 'Hello World 123',
            :slug => 'hello-world-123',
            :git_url => 'git@github.com:topicdesign/topkit-test-template.git',
            :uid => @uid
            # TODO: Add template JSON here
          ).first
          expect(site.id.present?).to eq(true)
        end
      end
      context 'with an empty git_url' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @empty_git_url.merge(:format => 'json')
          expect(response.status).to eq(500)
        end
      end
      context 'with a missing git_url' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @missing_git_url.merge(:format => 'json')
          expect(response.status).to eq(500)
        end
      end
      context 'with empty data' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @empty_data.merge(:format => 'json')
          expect(response.status).to eq(500)
        end
      end
    end
  end

  context 'When deploying a site' do
    context 'with a missing API key' do
      it 'returns 401' do
        post :deploy, :format => 'json'
        expect(response.status).to eq(401)
      end
    end
    context 'with an invalid API key' do
      it 'returns 401' do
        @request.headers['X-Api-Key'] = '123'
        post :deploy, :format => 'json'
        expect(response.status).to eq(401)
      end
    end
    context 'with a valid API key' do
      context 'and a valid uid' do
        it 'will deploy a site that already exists' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :deploy, @uid_data.merge(:format => 'json')
          expect(response.status).to eq(200)
        end
        # TODO: Change the JSON for the template (need a different reference)?
        it 'adds updated template config to the site in the database'
        it 'returns 500 when the site files do not exist'
      end
      context 'and an invalid uid' do
        it 'returns 500 when the uid is missing'
        it 'returns 500 when the uid is not in the database'
      end
    end
  end

end
