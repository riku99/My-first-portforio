class RelationshipsController < ApplicationController
  before_action :user_logged_in?

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    if params[:follow_page] == "following"
      @user = User.find(params[:user_id])
      redirect_to following_user_path(@user)
      #render "users/following"
    else
      redirect_to user_path(user)
    end
  end

  def destroy
    user = Relationship.find(params[:id]).followed    # followedはRelationshipのbelongs_toで作成
    current_user.unfollow(user)
    if params[:follow_page] == "following"
      @user = User.find(params[:user_id])
      redirect_to following_user_path(@user)
    else
      redirect_to user_path(user)
    end
  end

end
