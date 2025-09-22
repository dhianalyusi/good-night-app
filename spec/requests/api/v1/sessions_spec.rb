require 'swagger_helper'

RSpec.describe 'API V1 Sessions', type: :request do
  path '/api/v1/session/{user_id}/sleep' do
    post 'start sleep session' do
      tags 'Session'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer

      response '201', 'created' do
        let(:user) { User.create!(name: 'sleeper') }
        let(:user_id) { user.id }

        before do
          post sleep_api_v1_session_path(user_id)
        end

        it 'starts a session' do
          expect(response).to have_http_status(:created)
          body = JSON.parse(response.body)
          expect(body['message']).to be_present
          expect(body['session']).to be_present
        end
      end

      response '422', 'unprocessable' do
        let(:user) { User.create!(name: 'sleeper2') }
        let(:user_id) { user.id }

        before do
          # create an active session first
          user.sleep_sessions.create!(sleep_at: 1.hour.ago)
          post sleep_api_v1_session_path(user_id)
        end

        it 'returns 422 when active session exists' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  path '/api/v1/session/{user_id}/wake' do
    post 'end sleep session' do
      tags 'Session'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer

      response '200', 'ok' do
        let(:user) { User.create!(name: 'sleeper3') }
        let(:user_id) { user.id }

        before do
          user.sleep_sessions.create!(sleep_at: 2.hours.ago)
          post wake_api_v1_session_path(user_id)
        end

        it 'wakes and updates session' do
          expect(response).to have_http_status(:ok)
          body = JSON.parse(response.body)
          expect(body['message']).to be_present
          expect(body['session']['wake_at']).to be_present
        end
      end

      response '422', 'unprocessable' do
        let(:user) { User.create!(name: 'sleeper4') }
        let(:user_id) { user.id }

        before do
          post wake_api_v1_session_path(user_id)
        end

        it 'returns 422 when no active session' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  path '/api/v1/session/{user_id}/history' do
    get 'paginated history' do
      tags 'Session'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      response '200', 'ok' do
        let(:user) { User.create!(name: 'history_user') }
        let(:user_id) { user.id }

        before do
          3.times { user.sleep_sessions.create!(sleep_at: 1.day.ago) }
          get history_api_v1_session_path(user_id), params: { page: 1, per_page: 2 }
        end

        it 'returns paginated data' do
          expect(response).to have_http_status(:ok)
          parsed = JSON.parse(response.body)
          expect(parsed['data']).to be_an(Array)
          expect(parsed['pagination']).to be_present
        end
      end
    end
  end

  path '/api/v1/session/{user_id}/friends_weekly' do
    get 'friends weekly sessions' do
      tags 'Session'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer

      response '200', 'ok' do
        let(:user) { User.create!(name: 'u') }
        let(:friend) { User.create!(name: 'friend') }
        let(:user_id) { user.id }

        before do
          # make user follow friend
          Follow.create!(follower: user, followed: friend)
          # create a recent friend session
          friend.sleep_sessions.create!(sleep_at: 1.day.ago, wake_at: Time.current, duration: 3600)
          get friends_weekly_api_v1_session_path(user_id)
        end

        it 'returns friends sessions' do
          expect(response).to have_http_status(:ok)
          parsed = JSON.parse(response.body)
          expect(parsed['data']).to be_an(Array)
        end
      end
    end
  end
end
