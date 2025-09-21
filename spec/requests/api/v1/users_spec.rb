require 'swagger_helper'

RSpec.describe 'API V1 User', type: :request do
  path '/api/v1/user/{user_id}/follow' do
    post 'follow a user' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :followed_id, in: :query, type: :integer
      let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

      response '201', 'created' do
        let(:user) { User.create!(name: 'actor') }
        let(:other) { User.create!(name: 'target') }
        let(:user_id) { user.id }
        let(:followed_id) { other.id }

        before do
          post follow_api_v1_user_path(user_id), params: { followed_id: followed_id }.to_json, headers: headers
        end

        it 'returns 201' do
          expect(response).to have_http_status(:created)
        end
      end

      response '404', 'not found' do
        let(:user_id) { 9999 }
        let(:followed_id) { 9999 }

        before do
          post follow_api_v1_user_path(user_id), params: { followed_id: followed_id }.to_json, headers: headers
        end

        it 'returns 404' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  path '/api/v1/user/{user_id}/unfollow' do
    delete 'unfollow a user' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :followed_id, in: :query, type: :integer

      response '200', 'ok' do
        let(:user) { User.create!(name: 'actor2') }
        let(:other) { User.create!(name: 'target2') }
        let(:user_id) { user.id }
        let(:followed_id) { other.id }

        before do
          Follow.create!(follower: user, followed: other)
          delete unfollow_api_v1_user_path(user_id), params: { followed_id: followed_id }
        end

        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      response '404', 'not found' do
        let(:user_id) { 9999 }
        let(:followed_id) { 9999 }

        before do
          delete unfollow_api_v1_user_path(user_id), params: { followed_id: followed_id }
        end

        it 'returns 404' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
