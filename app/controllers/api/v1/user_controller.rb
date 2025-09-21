module Api
  module V1
    class UserController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      # Follow user. Expects params[:followed_id].
      #
      # Routes:
      #   POST   /api/v1/user/:user_id/follow
      #
      # Success: 201 with a message.
      # Failure: 422 with errors.
      def follow
        user = User.find(params[:followed_id])
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
      #   DELETE /api/v1/user/:user_id/unfollow
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

      # Get following user.
      #
      # Routes:
      #   GET /api/v1/user/:user_id/following
      #
      # Success: 200 with a message.
      def following
        user = User.find(params[:user_id])
        following = user.following

        render json: { data: following }, status: :ok
      end

      # Get follower user.
      #
      # Routes:
      #   GET /api/v1/user/:user_id/follower
      #
      # Success: 200 with a message.
      def followers
        user = User.find(params[:user_id])
        followers = user.followers

        render json: { data: followers }, status: :ok
      end
    end
  end
end
