class Api::V1::FollowsController < ApplicationController
  before_action :set_users, only: [:create, :destroy]

  def create
    follow = Follow.new(follower: @follower, followed: @followed)
  
    if follow.save
      render json: { message: "Now following #{@followed.name}" }, status: :ok
    else
      render json: { errors: follow.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    follow = Follow.find_by(follower: @follower, followed: @followed)
  
    if follow&.destroy
      render json: { message: "Unfollowed #{@followed.name}" }, status: :ok
    else
      render json: { errors: "Unable to unfollow user" }, status: :unprocessable_entity
    end
  end

  private

  def set_users
    @follower = User.find(params[:follower_id])
    @followed = User.find(params[:followed_id])
  end
end
