class DiscoveriesController < ApplicationController
  before_action :user_logged_in?, only: [:new, :create, :destroy]
  before_action :correct_owner?, only: [:destroy]
  def index
    @discoveries = Discovery.all
  end

  def show
    @discovery = Discovery.find(params[:id])
    @comments = Comment.where(discovery_id: @discovery)
  end

  def new
    @discovery = current_user.discoveries.new
  end

  def create
    @discovery = current_user.discoveries.new(discovery_params)
      if @discovery.save
        flash[:info] = "投稿しました"
        redirect_to discoveries_path
      else
        render "new"
      end
  end

  def destroy
    @discovery.destroy
    flash[:danger] = "削除しました"
    redirect_to discoveries_path
  end

  private
    def discovery_params
      params.require(:discovery).permit(:content)
    end

    def correct_owner?
      @discovery = current_user.discoveries.find_by(id: params[:id])
      if @discovery.nil?
        flash[:danger] = "他のユーザーのものは削除できません"
        redirect_to discoveries_path
      end
    end
end
