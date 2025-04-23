class UsersController < ApplicationController
  before_action :authenticate_request
  load_and_authorize_resource

  def index
    if current_user.role == 'Admin'
      @users = User.includes(:job_applications).all
    else
      @users = User.includes(:job_applications).where(id: current_user.id)
    end
    render json: @users.to_json(include: { job_applications: { only: [:id, :title, :description] } })
  end

  def show
    @user = User.includes(:job_applications).find(params[:id])

    if @user.id == current_user.id || current_user.role == 'Admin'
      render json: @user.to_json(include: { job_applications: { only: [:id, :title, :description] } })
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split.last if header
    decoded = JWT.decode(token, Rails.application.secret_key_base)[0] rescue nil
    @current_user = User.find(decoded["user_id"]) if decoded
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end