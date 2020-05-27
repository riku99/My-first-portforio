class RelationshipsController < ApplicationController
  before_action :user_logged_in?

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    if params[:follow_page] == "following"
      @other_user = User.find(params[:user_id])
      respond_to do |format|
      format.html { redirect_to following_user_path(@other_user) }
      format.js
      end
    else
      respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.js
      end
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed    # followedはRelationshipのbelongs_toで作成
    current_user.unfollow(@user)
    if params[:follow_page] == "following"
      @other_user = User.find(params[:user_id])
      respond_to do |format|
      format.html { redirect_to following_user_path(@other_user) }
      format.js
      end
    else
      respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.js
    end
    end
  end

end
