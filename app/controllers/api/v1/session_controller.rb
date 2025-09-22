module Api
  module V1
    class SessionController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      # Start a sleep session for the acting user.
      #
      # POST /api/v1/session/:user_id/sleep
      #
      # Success: 201 with created session.
      # Failure: 422 if an active session exists.
      def sleep
        active_session = current_user.sleep_sessions.find_by(wake_at: nil)
        if active_session
          return render json: {
            error: "User already has an active sleep session",
            session: active_session
          }, status: :unprocessable_entity
        end

        session = current_user.sleep_sessions.create!(
          sleep_at: Time.current
        )

        render json: { message: "User is sleeping", session: session }, status: :created
      end

      # End the most recent active sleep session for the acting user.
      #
      # POST /api/v1/session/:user_id/wake
      #
      # Success: 200 with updated session.
      # Failure: 422 if no active session.
      def wake
        session = current_user.sleep_sessions.where(wake_at: nil).order(sleep_at: :desc).first
        return render json: { error: "No active sleep session found" }, status: :unprocessable_entity unless session

        session.update!(
          wake_at: Time.current,
          duration: (Time.current - session.sleep_at).to_i
        )

        render json: { message: "User woke up", session: session }, status: :ok
      end

      # Return a paginated list of the user's sleep sessions.
      #
      # GET /api/v1/session/:user_id/history
      # Query params: page, per_page
      #
      # Success: 200 with { data: [...], pagination: {...} }
      def history
        sessions = current_user.sleep_sessions
                               .order(created_at: :desc)
                               .page(params[:page])
                               .per(params[:per_page] || 10)

        render json: {
          data: sessions,
          pagination: {
            current_page: sessions.current_page,
            next_page: sessions.next_page,
            prev_page: sessions.prev_page,
            total_pages: sessions.total_pages,
            total_count: sessions.total_count
          }
        }, status: :ok
      end

      # Return friends' sleep sessions for the last week (paginated).
      #
      # GET /api/v1/session/:user_id/friends_weekly
      # Query params: page, per_page
      #
      # Success: 200 with { data: [...], pagination: {...} }
      def friends_weekly
        sessions = SleepSession.where(user_id: current_user.following)
                               .where("created_at >= ?", 1.week.ago)
                               .order(duration: :desc)
                               .page(params[:page])
                               .per(params[:per_page] || 10)

        render json: {
          data: sessions,
          pagination: {
            current_page: sessions.current_page,
            next_page: sessions.next_page,
            prev_page: sessions.prev_page,
            total_pages: sessions.total_pages,
            total_count: sessions.total_count
          }
        }, status: :ok
      end
    end
  end
end
