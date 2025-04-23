class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  def current_user
    @current_user
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
      @current_user = User.find(decoded["user_id"])
      Rails.logger.debug "Authenticated User: #{@current_user.inspect}"  # Debug line to inspect the current user
    rescue JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
  