class JobApplicationsController < ApplicationController
  before_action :authenticate_request
  load_and_authorize_resource

  def index
    if current_user.role == 'Admin'
      @job_applications = JobApplication.all  # Admin can access all job applications
    else
      @job_applications = JobApplication.where(user_id: current_user.id)
    end
    render json: @job_applications
  end

  # GET /job_applications/:id
  def show
    @job_application = JobApplication.find(params[:id])

    if @job_application.user_id == current_user.id || current_user.role == 'Admin'
      render json: @job_application
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  # POST /job_applications
  def create
    @job_application = JobApplication.new(job_application_params)
    @job_application.user_id = current_user.id

    if @job_application.save
      render json: @job_application, status: :created
    else
      render json: { errors: @job_application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /job_applications/:id
  def update
    @job_application = JobApplication.find(params[:id])

    if @job_application.user_id == current_user.id || current_user.role == 'Admin'
      if @job_application.update(job_application_params)
        render json: @job_application
      else
        render json: { errors: @job_application.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  # DELETE /job_applications/:id
  def destroy
    @job_application = JobApplication.find(params[:id])
    if @job_application.user_id == current_user.id || current_user.role == 'Admin'
      @job_application.destroy
      head :no_content
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  private

  def job_application_params
    params.require(:job_application).permit(:title, :description)
  end
end
