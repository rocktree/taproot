require 'rails_helper'
require 'fileutils'

describe Api::V2::UsersController do

  before :all do
    @good_data = {
      :user => "{
        :name => 'Topic Design',
        :email => 'developers@topicdesign.com',
        :password => 'password',
        :password_confirmation => 'password',
      }"
    }
    @invalid_email = {
      :user => "{
        :name => 'Topic Design',
        :email => 'InvalidEmail',
        :password => 'password',
        :password_confirmation => 'password',
      }"
    }
    @unmatched_passwords = {
      :user => "{
        :name => 'Topic Design',
        :email => 'developers@topicdesign.com',
        :password => 'password123',
        :password_confirmation => 'password456',
      }"
    }
    @empty_user = { :user => "{}" }
    @empty_data = {}
  end

  context 'When listing all the users' do
    before(:all) do
      User.destroy_all
      user = create(:user)
      @valid_api_key = user.api_key
      create_list(:user, 9)
    end
    context 'with a missing API key' do
      it 'returns 401' do
        get :index, :format => 'json'
        expect(response.status).to eq(401)
      end
    end
    context 'with an invalid API key' do
      it 'returns 401' do
        @request.headers['X-Api-Key'] = '123'
        get :index, :format => 'json'
        expect(response.status).to eq(401)
      end
    end
    context 'with a valid API key' do
      before(:each) do
        @request.headers['X-Api-Key'] = @valid_api_key
        get :index, :format => 'json'
        @body = JSON.parse(response.body)
      end
      it 'returns 200' do
        expect(response.status).to eq(200)
      end
      it 'returns 10 users' do
        expect(@body.size).to eq(10)
      end
      it 'returns attributes of each user' do
        user = User.find_by_email(@body.first['email'])
        expect(@body.first['email']).to eq(user.email)
      end
    end
  end

  context 'When creating a user' do
    before :all do
      user = create(:user)
      @valid_api_key = user.api_key
    end
    context 'A missing API key' do
      it 'returns 401' do
        post :create, :format => 'json'
        expect(response.status).to eq(401)
      end
    end
    context 'An invalid API key' do
      it 'returns 401' do
        @request.headers['X-Api-Key'] = '123'
        post :create, :format => 'json'
        expect(response.status).to eq(401)
      end
    end
    context 'A valid API key' do
      context 'with a valid git_url' do
        it 'returns 200' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @good_data.merge(:format => 'json')
          expect(response.status).to eq(200)
        end
        it 'creates a user in the database' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @good_data.merge(:format => 'json')
          user = User.where(
            :name => 'Topic Design',
            :email => 'developers@topicdesign.com',
          ).first
          expect(user.id.present?).to eq(true)
        end
        it 'creates and returns a 32-character API key' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @good_data.merge(:format => 'json')
          expect(JSON.parse(response.body)['api_key'].size).to eq(32)
        end
      end
      context 'with an invalid email' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @invalid_email.merge(:format => 'json')
          expect(response.status).to eq(500)
        end
        it 'returns an invalid email message' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @invalid_email.merge(:format => 'json')
          expect(JSON.parse(response.body)['email'].first).to eq('is invalid')
        end
      end
      context 'with unmatched passwords' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @unmatched_passwords.merge(:format => 'json')
          expect(response.status).to eq(500)
        end
        it 'returns an unmatched passwords message' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @unmatched_passwords.merge(:format => 'json')
          msg = JSON.parse(response.body)['password_confirmation'].first
          expect(msg).to eq("doesn't match Password")
        end
      end
      context 'with an empty user' do
        it 'returns 500' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @empty_user.merge(:format => 'json')
          expect(response.status).to eq(500)
        end
        it 'returns an email error message' do
          @request.headers['X-Api-Key'] = @valid_api_key
          post :create, @empty_user.merge(:format => 'json')
          msg = JSON.parse(response.body)['email'].first
          expect(msg).to eq("can't be blank")
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

end
