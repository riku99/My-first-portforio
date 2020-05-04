class UsersController < ApplicationController
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
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)    # update_attributesと同じ。これは6.1でなくなるためupdateを使う
      flash[:info] = "更新しました"
      redirect_to @user
    else
      render "edit"
    end
  end

  def imgd
    user = User.find(params[:id])
    user.image.purge    # ユーザーの画像を削除
    #user.save    saveはupdateアクションで行うので、ここでは行わない
  end

  private

  def user_params
    params.require(:user).permit(:name, :acount_id, :email, :password, :password_confirmation, :image, :introduce,
                                 :score, :target_score)
  end

end
