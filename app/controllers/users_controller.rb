class UsersController < ApplicationController
  before_action :user_logged_in?, only: [:edit, :update, :imgd, :destroy, :following, :followers, :feed]
  before_action :correct_user?, only: [:edit, :update, :imgd, :feed]
  before_action :user_admin?, only: [:destroy]

  def new
    @user = User.new
  end

  def create
     @user = User.new(user_params)
      if @user.save
        log_in @user
        flash[:info] = "アカウントを登録しました"
        redirect_to user_path(@user)
      else
        render 'new'
      end
  end

  def show
    @user = User.find(params[:id])
    @discoveries = @user.discoveries
  end

  def change_to_comment
    user = User.find(params[:id])
    @comments = user.comments
  end

  def change_to_discovery
    user = User.find(params[:id])
    @discoveries = user.discoveries
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    @discoveries = Discovery.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: current_user.id)
  end

  def favorite
    user = User.find(params[:id])
    @discoveries = user.favo_discovery
  end

  def edit
    # before_actionでインスタンス変数を作るのでここでは作らない
  end

  def update
    if @user.update(user_params)    # update_attributesと同じ。これは6.1でなくなるためupdateを使う
      flash[:info] = "更新しました"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to root_path
  end

  def imgd
    user = User.find(params[:id])
    user.image.purge    # ユーザーの画像を削除
    #user.save    saveはupdateアクションで行うので、ここでは行わない
  end

  def following
    @user = User.find(params[:id])
  end

  def followers
    @user = User.find(params[:id])
  end



  private

  def user_params
    params.require(:user).permit(:name, :acount_id, :email, :password, :password_confirmation, :image, :introduce,
                                 :score, :target_score)
  end

  def user_logged_in?
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end

  def correct_user?
    @user = User.find(params[:id])
    unless @user == @current_user
      flash[:danger] = "ログインユーザーと違います"
      redirect_back(fallback_location: root_path)
    end
  end

  def user_admin?
    user = User.find(params[:id])
    unless current_user.admin?
      flash[:danger] = "削除できません"
      redirect_to root_path
    end
  end

end
