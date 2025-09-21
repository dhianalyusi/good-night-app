class ApplicationController < ActionController::API
  def record_not_found
    render json: { error: "User not found" }, status: :not_found
  end

  def current_user
    User.find(params[:user_id])
  end
end
