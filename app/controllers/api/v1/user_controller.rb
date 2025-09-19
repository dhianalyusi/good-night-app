module Api
  module V1
    class UserController < ActionController::API
      # Find and return the acting user from params[:user_id].
      def current_user
        User.find(params[:user_id])
      end

      # Follow user. Expects params[:followed_id].
      #
      # Routes:
      #   POST   /api/v1/users/:user_id/follow
      #
      # Success: 201 with a message.
      # Failure: 422 with errors.
      def follow
        user = User.find(params[:followed_id])
        unless user.present?
          render json: { error: "User not found" }, status: :unprocessable_entity
        end
        follow = Follow.new(follower: current_user, followed: user)

        if follow.save
          render json: { message: "You are now following #{user.name}" }, status: :created
        else
          render json: { error: follow.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # Unfollow user. Expects params[:followed_id].
      #
      # Routes:
      #   DELETE /api/v1/users/:user_id/unfollow
      #
      # Success: 200 with a message.
      # Failure: 404 if not following.
      def unfollow
        followed = User.find(params[:followed_id])
        follow = Follow.find_by(follower: current_user, followed: followed)

        if follow
          follow.destroy
          render json: { message: "You have unfollowed #{followed.name}" }, status: :ok
        else
          render json: { error: "You are not following #{followed.name}" }, status: :not_found
        end
      end
    end
  end
end
