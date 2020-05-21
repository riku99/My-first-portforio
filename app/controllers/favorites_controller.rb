class FavoritesController < ApplicationController
  before_action :user_logged_in?

  def create
    unless params[:comment]
    discovery = Discovery.find(params[:discovery_id])
    current_user.favo(discovery)
    if params[:page] == "index"
    redirect_to discoveries_path
    else
      redirect_to discovery_path(discovery)
    end
    else
    comment = Comment.find(params[:comment_id])
    current_user.favorite_comment(comment)
    if params[:page] == "discovery"
    redirect_to discovery_path(comment.discovery_id)
  else
    redirect_to comment_path(comment)
  end
  end
    end

  def destroy
    unless  params[:comment]
    discovery = Favorite.find(params[:id]).discovery
    current_user.unfavorite(discovery)
    if params[:page] == "index"
    redirect_to discoveries_path
    else
    redirect_to discovery_path(discovery)
    end
    else
    comment = Favorite.find(params[:id]).comment
    current_user.unfavorite_comment(comment)
    if params[:page] == "discovery"
    redirect_to discovery_path(comment.discovery_id)
    else
    redirect_to comment_path(comment)
    end
    end
  end

end
