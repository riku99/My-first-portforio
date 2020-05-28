class FavoritesController < ApplicationController
  before_action :user_logged_in?

  def create
    unless params[:comment]
    @discovery = Discovery.find(params[:discovery_id])
    current_user.favo(@discovery)
    #if params[:page] == "index"
    respond_to do |format|
    #format.html { redirect_to discoveries_path }
    format.js
    end

    else
    @comment = Comment.find(params[:comment_id])
    current_user.favorite_comment(@comment)
    #if params[:page] == "discovery"
    respond_to do |format|
    #format.html { redirect_to discovery_path(comment.discovery_id) }
    format.js
  end
  end
end

  def destroy
    unless  params[:comment]
    @discovery = Favorite.find(params[:id]).discovery
    current_user.unfavorite(@discovery)
    respond_to do |format|
      format.js
    end
    else
    @comment = Favorite.find(params[:id]).comment
    current_user.unfavorite_comment(@comment)
    respond_to do |format|
      format.js
    end
    end
  end

end
