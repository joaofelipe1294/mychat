class TeamUsersController < ApplicationController
  before_action :set_team_user, only: [:destroy, :update]

  def index
    @team_users = current_user.team_users.pending
    unless @team_users.empty?
      authorize! :read, @team_users.last
      render json: { team_user: @team_users.last }, status: :ok, include: [team: { only: [:slug]}]
    else
      render json: {}, status: :not_found
    end
  end

  def create
    @team_user = TeamUser.new team_user_params
    authorize! :create, @team_user
    if @team_user.save
      render json: { team_user: @team_user }, status: :created
    else
      render json: { errors: @team_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @team_user
    if @team_user.destroy
      render json: {}, status: :ok
    else
      render json: { errors: @team_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @team_user
    if @team_user.update team_user_params
      render json: { team_user: @team_user }, status: :ok, include: [team: { only: [:slug] }]
    else
      render json: { errors: @team_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def team_user_params
      params.require(:team_user).permit(:team_id, :user_id, :inviting_status)
    end

    def set_team_user
      @team_user = TeamUser.find params[:id]
    end

end
